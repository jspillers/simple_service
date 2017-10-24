class CommandOne
  include SimpleService

  command :modify_foo_bar

  def modify_foo_bar(foo:, bar:, command_one_success:, command_two_success:)
    modified_foo = "modified #{foo}"
    modified_bar = "modified #{bar}"

    if command_one_success
      success(
        modified_foo: modified_foo,
        modified_bar: modified_bar,
        command_two_success: command_two_success,
      )
    else
      failure(message: 'stuff went wrong with command one')
    end
  end
end

