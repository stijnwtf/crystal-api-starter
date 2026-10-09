module Routes::Tasks
  def self.parse(type : T.class, env) forall T
    T.from_json(env.request.body.try(&.gets_to_end) || "")
  rescue JSON::SerializableError | JSON::ParseException
    nil
  end

  def self.error(env, status : Int32, message : String)
    env.response.status_code = status
    {error: message}.to_json
  end

  def self.id(env) : Int64?
    env.params.url["id"].to_i64?
  end
end

get "/tasks" do
  Store.instance.all.to_json
end

get "/tasks/:id" do |env|
  task = Routes::Tasks.id(env).try { |id| Store.instance.find(id) }
  next Routes::Tasks.error(env, 404, "task not found") unless task
  task.to_json
end

post "/tasks" do |env|
  body = Routes::Tasks.parse(CreateTask, env)
  next Routes::Tasks.error(env, 400, "expected {\"title\": string}") unless body

  case title = Task.validate_title(body.title)
  in String
    env.response.status_code = 201
    Store.instance.create(title).to_json
  in NamedTuple
    Routes::Tasks.error(env, 422, title[:error])
  end
end

patch "/tasks/:id" do |env|
  id = Routes::Tasks.id(env)
  body = Routes::Tasks.parse(UpdateTask, env)
  next Routes::Tasks.error(env, 400, "expected {\"title\"?: string, \"completed\"?: bool}") unless body

  title = nil
  if raw = body.title
    case checked = Task.validate_title(raw)
    in String     then title = checked
    in NamedTuple then next Routes::Tasks.error(env, 422, checked[:error])
    end
  end

  task = id.try { |task_id| Store.instance.update(task_id, &.with(completed: body.completed, title: title)) }
  next Routes::Tasks.error(env, 404, "task not found") unless task
  task.to_json
end

delete "/tasks/:id" do |env|
  deleted = Routes::Tasks.id(env).try { |id| Store.instance.delete(id) }
  next Routes::Tasks.error(env, 404, "task not found") unless deleted
  env.response.status_code = 204
  nil
end
