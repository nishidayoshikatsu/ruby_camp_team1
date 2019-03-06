class Goal
  attr_accessor :bombing, :thumbup
  BOMB_IMG = Image.load('images/boom.png')
  THUMBUP_IMG = Image.load('images/thumbup.png')

  def begin_bomb
    self.bombing = 50
  end

  def begin_thumbup
    self.thumbup = 50
  end

  def judgement(current)
    return 0 unless current
    if ((@x - @margin)..(@x + @margin)).include?(current.body.p.x.to_i) && ((@y - @margin)..(@y + @margin)).include?(current.body.p.y.to_i)
      return current.class.name == @target_class_name ? 1 : -1
    else
      return 0
    end
  end

  def draw
    Window.draw(@x, @y, @img)
    if self.bombing
      self.bombing -= 1
      Window.draw(@x - BOMB_IMG.width / 2, @y - BOMB_IMG.height / 2, BOMB_IMG)
      self.bombing = nil if self.bombing == 0
    end

    if self.thumbup
      self.thumbup -= 1
      Window.draw(@x - THUMBUP_IMG.width / 2, @y - THUMBUP_IMG.height / 2 - 50 + self.thumbup, THUMBUP_IMG)
      self.thumbup = nil if self.thumbup == 0
    end
  end
end
