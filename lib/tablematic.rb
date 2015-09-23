require 'tablematic/helper'
require 'tablematic/builder'
require 'tablematic/configuration'

module Tablematic
  def self.configure
    # raise Error::AlreadyConfigured unless @configuration.nil?

    @configuration = Configuration.new
    yield(@configuration)
  end

  def self.configuration
    return @configuration || Configuration.new
  end
end
