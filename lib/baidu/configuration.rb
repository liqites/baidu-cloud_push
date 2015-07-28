require 'singleton'

module Baidu
  class Configuration
    include Singleton
    attr_accessor :mode

    def initialize
      @mode = :super
    end
  end
end
