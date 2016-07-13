module SimpleService
  class EnsureOrganizerIsValid < Organizer

    expects :expected_keys, :provided_keys, :provided_commands

    # makes sure validtion is only done once, prevents an infinite loop
    skip_validation true

    commands ValidatesExpectedKeys,
             ValidatesCommandsNotEmpty,
             ValidatesCommandsProperlyInherit

    def call
      super

      # dont return the keys within this internal service
      # so we dont pollute external service objects
      context.select { |k,v| !expects.include?(k) }
    end

  end
end
