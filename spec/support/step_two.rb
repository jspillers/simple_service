class StepTwo
  include SimpleService::Command

  def call(modified_foo:, modified_bar:)
    combined_foo_bar = "combined #{modified_foo} #{modified_bar}"

    if combined_foo_bar
      success(combined_foo_bar: combined_foo_bar)
    else
      failure(message: 'stuff went wrong with step two')
    end
  end
end

