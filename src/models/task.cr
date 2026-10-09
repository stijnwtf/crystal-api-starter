require "json"

struct Task
  include JSON::Serializable

  MAX_TITLE = 120

  getter id : Int64
  getter title : String
  getter? completed : Bool
  getter created_at : Time

  def initialize(@id, @title, @completed = false, @created_at = Time.utc)
  end

  def with(completed : Bool? = nil, title : String? = nil) : Task
    Task.new(id, title || self.title, completed.nil? ? completed? : completed, created_at)
  end

  # Returns the cleaned title, or an error message.
  def self.validate_title(raw : String?) : String | {error: String}
    title = raw.to_s.strip
    return {error: "title can't be blank"} if title.empty?
    return {error: "title is too long (max #{MAX_TITLE})"} if title.size > MAX_TITLE
    title
  end
end

# Request bodies. Unknown fields are ignored, missing required ones raise.
struct CreateTask
  include JSON::Serializable
  getter title : String
end

struct UpdateTask
  include JSON::Serializable
  getter title : String?
  getter completed : Bool?
end
