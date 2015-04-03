require 'pry'

class Something

  attr_accessor :context

  def initialize
    @context = {}
  end

  def define_some_methods
    self.class.class_eval do
      define_method 'test_define' do
        context[:test_define]
      end

      define_method 'test_define=' do |val|
        context[:test_define] = val
      end
    end
  end

end

s = Something.new
s.define_some_methods
binding.pry
s.test_define = 'balhhhasfd'
puts s.test_define
