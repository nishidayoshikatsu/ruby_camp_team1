class CP::Space
  STATIC_BODY = CP::Body.new_static
  STATIC_BODY.p = CP::Vec2.new(0, 0)

  def add(s)
    self.add_body(s.body) if s.body
    self.add_shape(s.shape)
  end

  def remove(s)
    self.remove_body(s.body) if s.body
    self.remove_shape(s.shape)
  end
end

class CPBase
  def self.walls
    walls = []
    walls << CPStaticBox.new(0, 50, 500, 55)
    walls << CPStaticBox.new(495, 55, 500, 550)
    #walls << CPStaticBox.new(0, 550, 500, 555)     # 発射したら追加
    walls << CPStaticBox.new(0, 55, 5, 550)
    walls   # 壁の情報が入ったリストを返す
  end

  def apply_force(x, y)
    body.apply_impulse(CP::Vec2.new(x, y), CP::Vec2.new(0, 0))
  end

  def set_eu(e, u)
    shape.e = e
    shape.u = u
  end
end