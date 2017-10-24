module SimpleService
  class Configuration
    attr_accessor :verbose_tracking

    def initialize
      @verbose_tracking = false
    end
  end
end
