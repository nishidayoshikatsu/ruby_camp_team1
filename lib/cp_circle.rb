class CPCircle < CPBase
  #COLLISION_TYPE = 0   # ??
  COLLISION_TYPE = 0
  attr_accessor :body, :shape

  def initialize(x, y, r, mass, color, e = 0.8, u = 0.8)
    moment = CP::moment_for_circle(mass, 0, r, CP::Vec2.new(0, 0))
    @body = CP::Body.new(mass, moment)
    @body.p = CP::Vec2.new(x + r, y + r)
    @shape = CP::Shape::Circle.new(@body, r, CP::Vec2.new(0, 0))
    @image = Image.new(r * 2, r * 2).circle_fill(r, r, r,color).line(0, r, r, r, C_RED)
    @r = r
    @x = x
    @y = y
    shape.e = e
    shape.u = u
  end

  def draw
    Window.draw_rot(@body.p.x - @r, @body.p.y - @r, @image, @body.a * 180.0 / Math::PI)     # 画面に円形を描画する
  end
end
