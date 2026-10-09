require "spec"
require "spec-kemal"
require "../src/app"

Spec.before_each { Store.instance.clear }

def json_headers
  HTTP::Headers{"Content-Type" => "application/json"}
end

def json_body
  JSON.parse(response.body)
end
