module SimpleService
  class ValidatesExpectedKeys < Command

    expects :expected_keys, :provided_keys

    skip_validation true # prevent infinite loop

    def call
      arguments_not_included = expected_keys.to_a - provided_keys.to_a

      if arguments_not_included.any?
        error_msg = 'keys required by the organizer but not found in the context: ' +
          arguments_not_included.join(', ')
        raise ExpectedKeyError, error_msg
      end
    end

  end
end
