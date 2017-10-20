module SimpleService
  module Organizer
    def self.included(klass)
      klass.extend ServiceBase::ClassMethods
      klass.include ServiceBase::InstanceMethods
      klass.extend ClassMethods
      klass.include InstanceMethods
    end

    module ClassMethods
      def commands(*args)
        @commands = args
      end
    end

    module InstanceMethods
      def initialize(**kwargs)
        @context = kwargs
      end

      def call
        Result.new
      end
    end
  end
end
