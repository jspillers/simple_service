module SimpleService
  class Command

    include ServiceBase::InstanceMethods
    extend ServiceBase::ClassMethods

    attr_accessor :context

    def initialize(context={})
      @context = context
      setup_call_chain
      define_getters_and_setters

      unless skip_validation
        ValidatesExpectedKeys.new(provided_keys: context.keys).call
      end
    end

    # call is where the command's behavior is defined
    # call should be overriden by whatever class inherits from
    # this class
    def call
      error_msg = "#{self.class} - does not define a call method"
      raise SimpleService::CallNotDefinedError , error_msg
    end

  end
end
