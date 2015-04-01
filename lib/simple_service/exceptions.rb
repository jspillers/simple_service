module SimpleService
  class OrganizerExpectedKeyError < StandardError; end;
  class OrganizerReturnKeyError < StandardError; end;
  class OrganizerCommandsNotDefinedError < StandardError; end;

  class CommandParentClassInvalidError < StandardError; end;
  class CommandExecuteNotDefinedError < StandardError; end;
  class CommandRequiredKeyNotFound < StandardError; end;
end
