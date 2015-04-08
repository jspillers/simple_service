require 'rubygems'
require 'simple_service'

class ConcatName < SimpleService::Command
  expects :first_name, :last_name
  returns :name

  def call
    self.name = "#{first_name} #{last_name}"
  end
end

class CreateHelloString < SimpleService::Command
  expects :name
  returns :hello

  def call
    self.hello ||= ''
    self.hello += "#{name}, say hello world!"
  end
end

class SayHelloMultipleTimes < SimpleService::Organizer
  expects :first_name, :last_name, :num_times
  returns :hello
  commands ConcatName, CreateHelloString

  # overriding the #call method on the organizer allows
  # you to do things like loop and call the service commands
  # multiple times
  def call
    num_times.times do
      super
    end
  end
end

result = SayHelloMultipleTimes.new(first_name: 'Ruby', last_name: 'Gem', num_times: 3).call
puts result[:hello]
