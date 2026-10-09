# Thread-safe in-memory store. Swap it for a database (e.g. crystal-pg or
# crystal-sqlite3 via crystal-db) by keeping the same methods.
class Store
  def initialize
    @tasks = {} of Int64 => Task
    @next_id = 1_i64
    @mutex = Mutex.new
  end

  def all : Array(Task)
    @mutex.synchronize { @tasks.values.sort_by!(&.id) }
  end

  def find(id : Int64) : Task?
    @mutex.synchronize { @tasks[id]? }
  end

  def create(title : String) : Task
    @mutex.synchronize do
      task = Task.new(@next_id, title)
      @tasks[task.id] = task
      @next_id += 1
      task
    end
  end

  def update(id : Int64, & : Task -> Task) : Task?
    @mutex.synchronize do
      if task = @tasks[id]?
        @tasks[id] = yield task
      end
    end
  end

  def delete(id : Int64) : Bool
    @mutex.synchronize { !@tasks.delete(id).nil? }
  end

  def clear
    @mutex.synchronize do
      @tasks.clear
      @next_id = 1_i64
    end
  end

  class_getter instance = new
end
