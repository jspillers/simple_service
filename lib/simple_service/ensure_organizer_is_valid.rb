module SimpleService
  class EnsureOrganizerIsValid < Organizer

    expects :expected_keys, :provided_keys, :provided_commands

    skip_validation true # false so as to not cause an infinite loop

    commands ValidatesExpectedKeys,
             ValidatesCommandsNotEmpty,
             ValidatesCommandsProperlyInherit

    def execute
      super

      # dont return the keys within this internal service
      # so we dont pollute external service objects
      context.select { |k,v| !expects.include?(k) }
    end

  end
end
