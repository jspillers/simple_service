module SimpleService

  class OrganizerCommandsNotDefinedError < StandardError; end;
  class CommandParentClassInvalidError < StandardError; end;
  class ExpectedKeyError < StandardError; end;
  class CallNotDefinedError < StandardError; end;
  class ReturnKeyError < StandardError; end;
end
