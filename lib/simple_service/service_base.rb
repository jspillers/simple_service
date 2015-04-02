module SimpleService
  module ServiceBase

    module ClassMethods
      def expects(*args)
        @expects = args
      end

      def returns(*args)
        @returns = args
      end
    end

    module InstanceMethods

      def setup_execute_chain
        self.class.class_eval do

          # grab the method object and hold onto it here
          execute_method = instance_method(:execute)

          # redefine the execute method, call the existing execute method object,
          # and then run return key checking... allows user to implement execute in
          # their individual command classes without having to call super or any
          # other method to return only specific context keys
          define_method :execute do
            execute_method.bind(self).call
            find_specified_return_keys
          end
        end
      end

      def find_specified_return_keys
        if returns.nil? || returns.empty?
          context
        else
          returns.inject({}) do |to_return, return_param|
            if context.has_key?(return_param)
              to_return[return_param] = context[return_param]
            else
              error_msg = "#{self.class} tried to return #{return_param}, but it did not exist in the context: #{context.inspect}"
              raise ReturnKeyError, error_msg
            end

            to_return
          end
        end
      end

      def expects
        self.class.instance_variable_get('@expects')
      end

      def returns
        self.class.instance_variable_get('@returns')
      end
    end

  end
end
