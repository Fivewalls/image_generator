module ImageGenerator
  class Configuration
    attr_accessor :protocol

    def initialize
      @protocol = 'https://'
    end
  end
end
