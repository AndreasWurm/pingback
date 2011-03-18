require 'spec_helper'
require 'pingback/client'

describe Pingback::Client do
  include TestHelpers

  before(:each) do
    @client = Pingback::Client.new

    @source = "http://myblog.com/articles/2"
    @target = "http://someblog.com/articles/16"
    @server = "http://myblog.com/pingback"
  end

  it "should check the targets header for the pingback server" do
    stub_request(:head, @target).to_return(pingback_in_header)
    stub_request(:post, @server).to_return(successful_response)

    @client.send(@source, @target)

    a_request(:head, @target).should have_been_made
    a_request(:post, @server).should have_been_made
  end

  it "should check the target for link tags which include the pingback server" do
    stub_request(:head, @target).to_return(pingback_in_body)
    stub_request(:get, @target).to_return(pingback_in_body)
    stub_request(:post, @server).to_return(successful_response)

    @client.send(@source, @target)

    a_request(:head, @target).should have_been_made
    a_request(:get, @target).should have_been_made
    a_request(:post, @server).should have_been_made
  end

  it "should unescape html special chars in the server uri taken from the link tag" do
    server_uri = 'http://myblog.com/%3Cpingback%3E&var=%22foo%22'
    escaped_server_uri = 'http://myblog.com/&lt;pingback&gt;&amp;var=&quot;foo&quot;'

    stub_request(:head, @target).to_return(pingback_in_body)
    stub_request(:get, @target).to_return(pingback_in_body(escaped_server_uri))
    stub_request(:post, server_uri).to_return(successful_response)

    @client.send(@source, @target)

    a_request(:post, server_uri).should have_been_made
  end

  it "should raise an exception if the target is no pingback-enabled resource" do
    stub_request(:head, @target).to_return(pingback_nowhere)
    stub_request(:get, @target).to_return(pingback_nowhere)

    lambda {
      @client.send(@source, @target)
    }.should raise_error(Pingback::InvalidTargetException)
  end

  it "should send an XML-RPC request to the pingback server" do
    stub_request(:head, @target).to_return(pingback_in_header)
    stub_request(:post, @server).to_return(successful_response)

    @client.send(@source, @target)
    a_request(:post, @server).with { |req|
      PrettyXML.write(req.body) == PrettyXML.write(pingback_request_xml)
    }.should have_been_made
  end

  it "should return the result of this request" do
    stub_request(:head, @target).to_return(pingback_in_header)
    stub_request(:post, @server).to_return(successful_response)

    @client.send(@source, @target).should ~ /Pingback for.*successful/
  end

  it "should raise a corresponding exception if a fault code is received" do
    stub_request(:head, @target).to_return(pingback_in_header)
    fault = {:body => fault_xml(16, "The source URI does not exist."), :status => 200, :headers => {'Content-Type' => 'text/xml'}}
    stub_request(:post, @server).to_return(fault)

    lambda {
      @client.send(@source, @target)
    }.should raise_error(XMLRPC::FaultException)
  end

  def pingback_in_header
    body = <<-STR
      <!DOCTYPE html>
      <html>
        <head>
          <title>Some Guys Blog</title>
        </head>
        <body>
          some stuff
        </body>
      </html>
    STR

    {:body => body, :status => 200,  :headers => { 'X-Pingback' => @server }}
  end

  def pingback_in_body(server = @server)
    body = <<-STR
      <!DOCTYPE html>
      <html>
        <head>
          <title>Some Guys Blog</title>
          <link rel="pingback" href="#{server}">
        </head>
        <body>
          some stuff
        </body>
      </html>
    STR

    {:body => body, :status => 200}
  end

  def pingback_nowhere
    body = <<-STR
      <!DOCTYPE html>
      <html>
        <head>
          <title>Some Guys Blog</title>
        </head>
        <body>
          some stuff
        </body>
      </html>
    STR

    {:body => body, :status => 200}
  end

  def successful_response
    {:body => successful_response_xml, :status => 200, :headers => {'Content-Type' => 'text/xml'}}
  end
end