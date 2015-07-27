require 'singleton'

module Baidu
  class Configuration
    include Singleton
    attr_accessor :mode
  end
end
