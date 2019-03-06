class GoalCircle < Goal
  def initialize(x, y, r)
    @x, @y = x, y
    @img = Image.new(r * 2, r * 2).circle_fill(r, r, r,C_YELLOW)
    @target_class_name = 'CPCircle'
    @margin = 15
  end
end