require_relative 'cp_static_box'

class RubyStaticBox < CPStaticBox
  COLLISION_TYPE = 2
  def initialize(x, y, e = 0.8, u = 0.8)
    image = Image.load('images/ruby_image.png')
    super(x, y, x + image.width, y + image.height, e, u)
    @image = image
  end
end
