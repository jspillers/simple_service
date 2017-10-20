require_relative 'step_one'
require_relative 'step_two'

class BasicOrganizer
  include SimpleService::Organizer

  expects :foo, :bar

  optional :blah

  commands StepOne,
           StepTwo,
           :step_three

  def step_three(combined_foo_bar:)
    success(final_result: combined_foo_bar)
  end
end

