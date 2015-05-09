module SimpleService
  module ServiceBase

    module ClassMethods
      def expects(*args)
        @expects = args
      end

      def returns(*args)
        @returns = args
      end

      def skip_validation(skip=true)
        @skip_validation = skip
      end
    end

    module InstanceMethods

      def setup_call_chain
        self.class.class_eval do

          # grab the method object and hold onto it here
          call_method = instance_method(:call)

          # redefine the call method, execute the existing call method object,
          # and then run return key checking... allows user to implement call in
          # their individual command classes without having to call super or any
          # other method to return only specific context keys
          define_method :call do
            call_method.bind(self).call
            return_context_with_success_status
          end
        end
      end

      def symbolize_context_keys
        context.keys.each do |key|
          context[key.to_sym] = context.delete(key)
        end
      end

      def return_context_with_success_status
        _context = find_specified_return_keys

        # only automatically set context[:success] on Organizers and only if its not already set
        if !_context.has_key?(:success) && self.class.ancestors.include?(SimpleService::Organizer)
          _context[:success] = true
        end

        _context
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
        self.class.instance_variable_get('@expects') || []
      end

      def returns
        self.class.instance_variable_get('@returns') || []
      end

      def skip_validation
        self.class.instance_variable_get('@skip_validation')
      end

      def all_context_keys
        (expects + returns + ['message', 'success']).uniq
      end

      def failure!(message = nil)
        context[:success] = false
        context[:message] = message || 'There was a problem'
      end

      def define_getters_and_setters
        all_context_keys.each do |key|
          self.class.class_eval do

            # getter
            define_method key do
              self.context[key]
            end

            # setter
            define_method "#{key}=" do |val|
              self.context[key] = val
            end

          end
        end
      end

    end

  end
end
