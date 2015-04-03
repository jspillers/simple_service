module SimpleService
  class Command

    include ServiceBase::InstanceMethods
    extend ServiceBase::ClassMethods

    attr_accessor :context

    def initialize(context={})
      @context = context
      setup_execute_chain
      define_getters_and_setters
    end

    # execute is where the command's behavior is defined
    # execute should be overriden by whatever class inherits from
    # this class
    def execute
      error_msg = "#{self.class} - does not define an execute method"
      raise SimpleService::ExecuteNotDefinedError , error_msg
    end

    private

    def define_getters_and_setters
      (expects + returns).each do |key|
        self.class.class_eval do

          # getter
          define_method key do
            context[key]
          end

          # setter
          define_method "#{key}=" do |val|
            context[key] = val
          end

        end
      end
    end

  end
end
