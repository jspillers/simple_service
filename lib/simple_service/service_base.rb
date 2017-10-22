module SimpleService
  module ServiceBase
    module ClassMethods
      # allow execution of the service or commands from the
      # class level for those that prefer that style
      def call(context = {})
        new.call(context)
      end
    end

    module InstanceMethods
    end
  end
end
