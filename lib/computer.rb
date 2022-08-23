class Computer 

  attr_reader :name, :color

  def initialize(color)
    @name = "Computer#{rand(100..999)}"
    @color = color
  end

end