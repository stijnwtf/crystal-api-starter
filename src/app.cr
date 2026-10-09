require "kemal"
require "./models/*"
require "./store"
require "./routes/*"

module App
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}
end

# JSON everywhere, including errors.
before_all do |env|
  env.response.content_type = "application/json"
end

error 404 do |_|
  {error: "Not found"}.to_json
end

error 500 do |_, ex|
  Log.error(exception: ex) { "Unhandled error" }
  {error: "Internal server error"}.to_json
end

{% unless @top_level.has_constant?("SPEC") %}
  Kemal.config.port = ENV.fetch("PORT", "3000").to_i
  Kemal.run
{% end %}
