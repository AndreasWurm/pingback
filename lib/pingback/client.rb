require 'net/http'
require 'uri'
require 'xmlrpc/client'
require 'nokogiri'

module Pingback
  # This class allows to send pingback requests.
  class Client
    # send an pingback request to the targets associated pingback server.
    #
    # @param [String] source_uri the address of the site containing the link.
    # @param [String] target_uri the target of the link on the source site.
    # @raise [Pingback::InvalidTargetException] raised if the target is not a pingback-enabled resource
    # @raise [XMLRPC::FaultException] raised if the server responds with a faultcode
    # @return [String] message indicating that the request was successful
    def ping(source_uri, target_uri)
      header = request_header target_uri
      pingback_server = header['X-Pingback']

      unless pingback_server
        doc = Nokogiri::HTML(request_all(target_uri).body)
        link = doc.xpath('//link[@rel="pingback"]/attribute::href').first
        pingback_server = URI.escape(link.content) if link
      end

      raise InvalidTargetException unless pingback_server

      send_pingback pingback_server, source_uri, target_uri
    end

    private
    def request_header(uri)
      url = URI.parse uri
      req = Net::HTTP::Head.new url.path
      Net::HTTP.start(url.host, url.port) {|http|
         http.request req
      }
    end
    
    def request_all(uri)
      url = URI.parse uri
      req = Net::HTTP::Get.new url.path
      Net::HTTP.start(url.host, url.port) {|http|
         http.request req
      }
    end

    def send_pingback(server, source_uri, target_uri)
      server_uri = URI.parse server
      c = XMLRPC::Client.new server_uri.host, server_uri.path, server_uri.port
      c.call('pingback.ping', source_uri, target_uri)
    end
  end
end