class MultipleOutcomeCalls
  include SimpleService

  commands :command_one,
           :command_two,

  def command_one(**kwargs)
    success(kwargs.merge(foo: kwargs[:foo].capitalize))
    success(kwargs.merge(foo: kwargs[:foo].upcase))
  end

  def command_two(**kwargs)
    success(bar: kwargs[:bar].capitalize)
    success(foo: kwargs[:foo].upcase, bar: kwargs[:bar].upcase)
  end
end