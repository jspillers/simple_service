class CombineFooBar
  include SimpleService

  def call(modified_foo:, modified_bar:, command_two_success:)
    combined_foo_bar = "combined #{modified_foo} #{modified_bar}"

    if command_two_success
      success(combined_foo_bar: combined_foo_bar)
    else
      failure(message: 'stuff went wrong with command two')
    end
  end
end
