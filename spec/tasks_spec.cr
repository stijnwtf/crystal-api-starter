require "./spec_helper"

describe "Tasks API" do
  it "reports health" do
    get "/health"
    response.status_code.should eq 200
    json_body["status"].should eq "ok"
  end

  it "creates and lists tasks" do
    post "/tasks", headers: json_headers, body: {title: "  Learn Crystal "}.to_json
    response.status_code.should eq 201
    json_body["title"].should eq "Learn Crystal"
    json_body["completed"].should be_false

    get "/tasks"
    json_body.as_a.size.should eq 1
  end

  it "rejects blank and malformed bodies" do
    post "/tasks", headers: json_headers, body: {title: "   "}.to_json
    response.status_code.should eq 422

    post "/tasks", headers: json_headers, body: "nope"
    response.status_code.should eq 400
  end

  it "updates and deletes a task" do
    task = Store.instance.create("Ship it")

    patch "/tasks/#{task.id}", headers: json_headers, body: {completed: true}.to_json
    response.status_code.should eq 200
    json_body["completed"].should be_true
    json_body["title"].should eq "Ship it"

    delete "/tasks/#{task.id}"
    response.status_code.should eq 204
    Store.instance.all.should be_empty
  end

  it "returns 404 for unknown tasks and routes" do
    get "/tasks/999"
    response.status_code.should eq 404
    delete "/tasks/abc"
    response.status_code.should eq 404
    get "/nope"
    response.status_code.should eq 404
  end
end
