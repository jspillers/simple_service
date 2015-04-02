require 'pry'

module CommandBase

  def do_the_thing
    binding.pry
    self.class.class_eval do
      alias old_execute execute

      define_method(:execute) do
        old_execute
        puts 'new execute'
      end

    end
  end

end

class Command

  #puts 'loaded Command'

  include CommandBase

  def execute
    raise 'gota override me'
  end

  def initialize
    do_the_thing
  end

end

class CustomCommand < Command

  #puts 'loaded CustomCommand'

  def execute
    puts 'old execute'
  end
end

CustomCommand.new.execute
