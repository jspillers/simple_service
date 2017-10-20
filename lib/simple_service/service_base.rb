module SimpleService
  module ServiceBase
    module ClassMethods
      def expects(*args)
        @expects = args
      end

      def get_expects
        @expects || []
      end

      def optional(*args)
        @optional = args
      end

      def get_optional
        @optional || []
      end

      # allow execution of the service or commands from the
      # class level for those that prefer that style
      def call(context = {})
        new(context).call
      end
    end

    module InstanceMethods
      def failed?
        !successful?
      end

      def halted?
        context.has_key?(:halt) || context[:halt] == true
      end

      def successful?
        !context.has_key?(:success) || context[:success] == true
      end

      def expects
        self.class.get_expects
      end

      def optional
        self.class.get_optional
      end

      def returns
        self.class.get_returns
      end

      def all_context_keys
        (expects + optional + returns + ['message', 'success']).uniq
      end

      def organizer?
        self.class.ancestors.include?(SimpleService::Organizer)
      end
    end
  end
end
