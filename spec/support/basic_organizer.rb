require_relative 'command_one'
require_relative 'command_two'

class BasicOrganizer
  include SimpleService::Organizer

  commands CommandOne, CommandTwo
end

