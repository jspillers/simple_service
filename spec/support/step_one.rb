class StepOne
  include SimpleService::Command

  def call(foo:, bar:)
    modified_foo = "modified #{foo}"
    modified_bar = "modified #{bar}"

    if true
      success(
        modified_foo: modified_foo,
        modified_bar: modified_bar
      )
    else
      failure(message: 'stuff went wrong with step one')
    end
  end
end

