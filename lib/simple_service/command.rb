module SimpleService
  class Command

    include ServiceBase::InstanceMethods
    extend ServiceBase::ClassMethods

    attr_accessor :context

    def initialize(context={})
      @context = context
      setup_execute_chain
      define_getters_and_setters

      unless skip_validation
        ValidatesExpectedKeys.new(provided_keys: context.keys).execute
      end
    end

    # execute is where the command's behavior is defined
    # execute should be overriden by whatever class inherits from
    # this class
    def execute
      error_msg = "#{self.class} - does not define an execute method"
      raise SimpleService::ExecuteNotDefinedError , error_msg
    end

  end
end
