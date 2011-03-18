require 'pingback/client'
require 'pingback/server'
require 'xmlrpc/parser'

module Pingback
  # Exception which represents fault code 0, the generic fault code.
  class GenericFaultException < XMLRPC::FaultException
    def initialize
      super(0, "generic fault.")
    end
  end

  # Exception which represents fault code 16, the source URI does not exist.
  class InexistentSourceException < XMLRPC::FaultException
    def initialize
      super(16, "The source URI does not exist.")
    end
  end

  # Exception which represents fault code 17, the source URI does not contain a link to the target URI,
  # and so cannot be used as a source.
  class InvalidSourceException < XMLRPC::FaultException
    def initialize
      super(17, "The source URI does not contain a link to the target URI, and so cannot be used as a source.")
    end
  end

  # Exception which represents fault code 32, the target URI does not exist.
  class InexistentTargetException < XMLRPC::FaultException
    def initialize
      super(32, "The target URI does not exist.")
    end
  end

  # Exception which represents fault code 33, the specified target URI cannot be used as a target.
  class InvalidTargetException < XMLRPC::FaultException
    def initialize
      super(33, "The specified target URI cannot be used as a target.")
    end
  end

  # Exception which represents fault code 48, the pingback has already been registered.
  class AlreadyRegisteredException < XMLRPC::FaultException
    def initialize
      super(48, "The pingback has already been registered.")
    end
  end
end
