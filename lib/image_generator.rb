require "image_generator/version"
require 'image_generator/configuration'
require 'image_generator/errors'
require 'image_generator/base'

module ImageGenerator
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
