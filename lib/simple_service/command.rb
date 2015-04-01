module SimpleService
  class Command

    attr_accessor :context

    def initialize(context={})
      @context = context
    end

  end
end
