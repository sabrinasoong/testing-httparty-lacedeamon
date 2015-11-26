require 'spec_helper'
require 'httparty'

describe "Test Suite sends a post request" do
  it "should create a new post in collection" do
    #Execute    
    r = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: {title: "Sabrina's been testing~~^^", due: "2016-02-03"}
    #Verify
    expect(r["title"]).to eq "Sabrina's been testing~~^^"
    #Teardown
    HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{r["id"]}"
  end

  it "should fail to make a post without proper arguments" do
    #expect
  end

  it "should" do

  end

  it "should" do

  end
end

describe "Test Suite sends a get request" do
  it "should read get the hash at a specific ID" do

  end

  it "should return an empty hash from an empty ID" do
  
  end
  
  it "should return all IDs if collection is requested" do
    
  end
end

describe "Test Suite sends a put request" do
  it "should update a single todo from an ID" do

  end
end

describe "Test Suite sends a patch request" do
  it "should" do

  end
end

describe "Test suite sends a delete request" do
  it "should delete a single todo" do

  end
  
  it "should not delete todo collection" do

  end
  
  it "should not delete todo collection" do

  end
end
