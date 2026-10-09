get "/health" do
  {status: "ok", version: App::VERSION}.to_json
end
