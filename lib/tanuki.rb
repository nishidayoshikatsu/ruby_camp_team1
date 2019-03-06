class Tanuki
  attr_reader :x, :y, :img
  def initialize
    @img = Image.load('images/tanuki.png')
    @x = 0
    @y = 2
    @dir = 2
  end

  def move
    @x += @dir
    if @x >= 920
      @dir = -2
    end
    if @x <= 0
      @dir = 2
    end
  end

  def draw
    Window.draw(@x, @y, @img)
  end
end
