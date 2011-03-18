require "rubygems"
require "bundler"
Bundler.setup(:default, :development)
require 'webmock/rspec'
require 'pretty-xml'



module TestHelpers

  def pingback_request_xml
    <<-STR
      <methodCall>
        <methodName>pingback.ping</methodName>
        <params>
          <param>
            <value>
              <string>#{@source}</string>
            </value>
          </param>
          <param>
            <value>
              <string>#{@target}</string>
            </value>
          </param>
        </params>
      </methodCall>
    STR
  end

  def fault_xml(fault_code, fault_string)
    <<-STR
      <methodResponse>
        <fault>
          <value>
            <struct>
              <member>
                <name>faultCode</name>
                <value>
                  <i4>#{fault_code}</i4>
                </value>
              </member>
              <member>
                <name>faultString</name>
                <value>
                  <string>#{fault_string}</string>
                </value>
              </member>
            </struct>
          </value>
        </fault>
      </methodResponse>
    STR
  end

  def successful_response_xml
     <<-STR
    <methodResponse>
       <params>
          <param>
             <value>
                <string>Pingback for source #{@source} and target #{@target} was successful</string>
             </value>
          </param>
       </params>
    </methodResponse>
    STR
  end

end