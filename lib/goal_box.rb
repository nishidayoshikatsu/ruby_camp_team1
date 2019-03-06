class GoalBox < Goal
  def initialize(x, y, size)
    @x, @y = x, y
    @img = Image.new(size, size).fill(C_BLUE)
    @target_class_name = 'CPBox'
    @margin = 15
  end
end