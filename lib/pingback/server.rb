require 'net/http'
require 'uri'
require 'xmlrpc/server'
require 'nokogiri'
require 'rack'

module Pingback
  # This class is intended to be used to handle pingback requests.
  # It conforms to the rack interface.
  # How a pingback request should be registered has to be defined in a Proc which must be supplied to the constructor.
  class Server
    # A new instance of Server.
    # @param [Proc, #call] request_handler proc which implements the pingback registration and takes the source_uri and the target_uri
    #     as params. Use the exceptions defined in Pingback to indicate errors.
    def initialize(request_handler)
      @request_handler = request_handler
      setup_xmlrpc_handler
    end

    def call(env)

        request = Rack::Request.new(env)

        xml_response = @xmlrpc_handler.process(request.body)

        [200, {'Content-Type' => 'text/xml'}, xml_response]
    end

    private
    def setup_xmlrpc_handler
      @xmlrpc_handler = XMLRPC::BasicServer.new
      @xmlrpc_handler.add_handler('pingback.ping') do |source_uri, target_uri|

        @request_handler.call(source_uri, target_uri)

        "Pingback for source #{source_uri} and target #{target_uri} was successful"
      end
    end
  end
end