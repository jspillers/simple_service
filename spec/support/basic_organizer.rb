require_relative 'command_one'
require_relative 'command_two'

class BasicOrganizer
  include SimpleService

  command :command_one
  command :command_two
  commands CommandOne, CommandTwo

  def command_one(**kwargs)
    success(kwargs.merge(foo: 'FOO'))
  end

  def command_two(**kwargs)
    success(kwargs.merge(bar: 'BAR'))
  end
end

