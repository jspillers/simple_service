class LoopingService
  include SimpleService

  commands :add_one

  def call(kwargs)
    count = kwargs

    3.times do
      count = super(count)
    end

    count
  end

  def add_one(count:)
    success(count: count + 1)
  end
end

