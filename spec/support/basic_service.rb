require_relative 'modify_foo_bar'
require_relative 'combine_foo_bar'

class BasicService
  include SimpleService

  commands :upcase_foo,
           :upcase_bar,
           ModifyFooBar,
           CombineFooBar

  def upcase_foo(**kwargs)
    success(kwargs.merge(foo: kwargs[:foo].upcase))
  end

  def upcase_bar(**kwargs)
    success(kwargs.merge(bar: kwargs[:bar].upcase))
  end
end

