require 'spec_helper'
require 'pingback'
require 'rack/test'

describe Pingback::Server do
  include Rack::Test::Methods
  include TestHelpers

  def app
    @app
  end

  before(:each) do
    @source = "http://myblog.com/articles/3"
    @target = "http://someblog.com/articles/17"
  end

  it "should return the corresponding fault if an exception is raised" do
    proc = Proc.new do |source, target|
      raise Pingback::InexistentSourceException
    end
    
    @app = Pingback::Server.new proc

    post '/', {}, {'rack.input' => pingback_request_xml}

    PrettyXML.write(last_response.body).should == PrettyXML.write(fault_xml(16, "The source URI does not exist."))
  end

  it "should return a string if pingback registration was successful" do
    @app = Pingback::Server.new Proc.new {|source, target|}

    post '/', {}, {'rack.input' => pingback_request_xml}

    PrettyXML.write(last_response.body).should == PrettyXML.write(successful_response_xml)
  end
end