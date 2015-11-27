require 'spec_helper'
require 'httparty'

describe "Test Suite sends a post request" do
  
  it "should create a new post in collection" do
    #Execute    
    p = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: {title: "Sabrina's been testing", due: "2016-02-03"}
    #Verify
    expect(p["title"]).to eq "Sabrina's been testing"
    expect(p.code).to eq 201
    expect(p.message).to eq "Created"
    #Teardown
    HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{p["id"]}"
  end

  it "should fail to make a post without proper arguments" do
    #Execute
    p = HTTParty.post "http://lacedeamon.spartaglobal.com/todos"
    expect(p).to include "You must provide the following parameters: <title> and <due>."
    expect(p.code).to eq 422
  end
  
  it "should fail to make a post with given a specific id" do
    #Execute
    p = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: {title: "Sabrina thinks this will post", due: "2015-11-27"}
    p2 = HTTParty.post "http://lacedeamon.spartaglobal.com/todos/#{p["id"]}", query: {title: "Sabrina thinks this will definitely fail", due: "2015-11-27"}
    #Verify
    expect(p2.to_s).to eq "Method Not Allowed. To create a new todo, POST to the collection, not an item within it."
    expect(p2.code).to eq 405
    expect(p2.message).to eq "Method Not Allowed"
    #Teardown
    HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{p["id"]}"
  end
  
end

describe "Test Suite sends a get request" do
  
  it "should read get the hash at a specific ID" do
    #Setup
    p = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: {title: "Sabrina's been testing", due: "2015-11-27"}
    #Execute
    g = HTTParty.get "http://lacedeamon.spartaglobal.com/todos/#{p["id"]}"
    #Verify
    expect(g["title"]).to eq "Sabrina's been testing"
    expect(g.code).to eq 200
    expect(g.message).to eq "OK"
    #Teardown
    HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{p["id"]}"
  end

  it "should return array of collection if collection is requested" do
    #Execute
    g = HTTParty.get "http://lacedeamon.spartaglobal.com/todos"
    #Verify
    expect(g).to be_a(Array)
    expect(g.code).to eq 200
    expect(g.message).to eq "OK"
  end
  
  it "should not be able to get a non-existing todo" do
    #Setup
    p = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: {title: "Sabrina's been testing", due: "2015-11-27"}
    HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{p["id"]}"
    #Execute
    h = HTTParty.get "http://lacedeamon.spartaglobal.com/todos/#{p["id"]}", query: {title: "This ain't gonna work!", due: "2020-10-10"}
    #Verify
    expect(h.to_s).to eq ""
    expect(h.code).to eq 404
    expect(h.message).to eq "Not Found"
  end
  
end

describe "Test Suite sends a put request" do
  
  it "should update a single todo fully using an ID" do
    #Setup
    p = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: {title: "Sabrina's been testing", due: "2015-11-27"}
    #Execute
    t = HTTParty.put "http://lacedeamon.spartaglobal.com/todos/#{p["id"]}", query: {title: "Title has been changed!", due: "2016-03-26"}
    #Verify
    g = HTTParty.get "http://lacedeamon.spartaglobal.com/todos/#{t["id"]}"
    expect(g["title"]).to eq "Title has been changed!" 
    expect(t.code).to eq 200
    expect(t.message).to eq "OK"
    #Teardown
    HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{p["id"]}"
  end
  
  it "should NOT be able to update a non-existing single todo" do
    #Setup
    p = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: {title: "Sabrina's been testing", due: "2015-11-27"}
    HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{p["id"]}"
    #Execute
    h = HTTParty.put "http://lacedeamon.spartaglobal.com/todos/#{p["id"]}", query: {title: "This ain't gonna work!", due: "2020-10-10"}
    #Verify
    expect(h.to_s).to eq ""
    expect(h.code).to eq 404
    expect(h.message).to eq "Not Found"
  end
  
  it "should NOT update the todos collection" do
    #Execute
    h = HTTParty.put "http://lacedeamon.spartaglobal.com/todos"
    #Verify
    expect(h.code).to eq 405
    expect(h.message).to eq "Method Not Allowed"
  end
  
end

describe "Test Suite sends a patch request" do
  
  it "should update a single todo partially using an ID" do
    #Setup
    p = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: {title: "Sabrina's been testing", due: "2015-11-27"}
    #Execute
    h = HTTParty.patch "http://lacedeamon.spartaglobal.com/todos/#{p["id"]}", query: {title: "Title has been changed!"}
    #Verify
    g = HTTParty.get "http://lacedeamon.spartaglobal.com/todos/#{p["id"]}"
    expect(g["title"]).to eq "Title has been changed!" 
    expect(g["due"]).to eq "2015-11-27"
    expect(h.code).to eq 200
    expect(h.message).to eq "OK"
    #Teardown
    HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{p["id"]}"
  end
  
  it "should NOT be able to update a non-existing single todo" do
    #Setup
    p = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: {title: "Sabrina's been testing", due: "2015-11-27"}
    HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{p["id"]}"
    #Execute
    h = HTTParty.patch "http://lacedeamon.spartaglobal.com/todos/#{p["id"]}", query: {title: "This ain't gonna work!"}
    #Verify
    expect(h.to_s).to eq ""
    expect(h.code).to eq 404
    expect(h.message).to eq "Not Found"
  end
  
  it "should NOT update the todos collection" do
    #Execute
    h = HTTParty.patch "http://lacedeamon.spartaglobal.com/todos"
    #Verify
    expect(h.code).to eq 405
    expect(h.message).to eq "Method Not Allowed"
    end
  
end

describe "Test suite sends a delete request" do
  
  it "should delete a single todo" do
    #Setup
    p = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: {title: "Sabrina's been testing", due: "2015-11-27"}
    #Execute
    d = HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{p["id"]}"
    #Verify
    expect(d.to_s).to eq ""
    expect(d.code).to eq 204
    expect(d.message).to eq "No Content"
  end
  
  it "should not be able to delete a single non-existing todo" do
    #Setup
    p = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: {title: "Sabrina's been testing", due: "2015-11-27"}
    #Execute
    d = HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{p["id"]}"
    expect(d.to_s).to eq ""
    expect(d.code).to eq 204
    expect(d.message).to eq "No Content"
    #Verify
    d = HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{p["id"]}"
    expect(d.to_s).to eq ""
    expect(d.code).to eq 404
    expect(d.message).to eq "Not Found"
  end
  
  it "should not delete todo collection" do
    #Execute
    d = HTTParty.delete "http://lacedeamon.spartaglobal.com/todos"
    #Verify
    expect(d.to_s).to eq "Method Not Allowed. You cannot delete the Collection."
    expect(d.code).to eq 405
    expect(d.message).to eq "Method Not Allowed"
  end

end
