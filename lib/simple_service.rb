require 'simple_service/result'
require 'simple_service/configuration'
require 'simple_service/version'

module SimpleService
  def self.included(klass)
    klass.extend ClassMethods
    klass.include InstanceMethods
    self.configure
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  module ClassMethods
    def command(command_name)
      @commands ||= []
      @commands << command_name
    end

    def commands(*args)
      @commands ||= []
      @commands += args
    end

    def call(kwargs={})
      service = self.new

      # if kwargs is a result obj then pull its hash out via #value
      service.result.value = kwargs.is_a?(Result) ? kwargs.value : kwargs

      get_commands(service).each do |cmnd|
        service = execute_command(cmnd, service)
        break if service.result.failure?
      end

      service.result
    end

    def get_commands(service)
      if !@commands.nil? && @commands.any?
        @commands
      elsif service.respond_to?(:call)
        [:call]
      else
        raise "No commands defined for #{self.to_s}, define at least one " \
          'command or implement the #call method'
      end
    end

    def execute_command(cmnd, service)
      service.current_command = cmnd

      command_output = if cmnd.is_a?(Class)
        cmnd.call(service.result.value)
      elsif cmnd.is_a?(Symbol)
        if service.method(cmnd).arity.zero?
          service.public_send(cmnd)
        else
          service.public_send(cmnd, **service.result.value)
        end
      end

      if command_output.is_a?(Result)
        service.result.append_result(command_output)
      end

      service
    end
  end

  module InstanceMethods
    def result
      @result ||= Result.new
    end

    def current_command
      @current_command
    end

    def current_command=(cmnd)
      @current_command = cmnd
    end

    def commands
      self.class.instance_variable_get('@commands') || []
    end

    def success(result_value)
      result.success!(self.class, current_command, result_value)
    end

    def failure(result_value)
      result.failure!(self.class, current_command, result_value)
    end
  end
end
