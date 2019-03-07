module Result
  class Director
    def initialize
      @bg_img = Image.load('./images/result.png')
      @font = Font.new(60)
    end

    def play
      Window.draw(0, 0, @bg_img)
      # Scene.score = 100
      Window.draw_font(300, 400, "#{Scene.score}", @font, color: C_RED)

    #   Window.draw_font(100, 400, 'Score:', @font, color: C_RED)
    #   Window.draw_font(100, 600, 'Push Enter key', @font, color: C_RED)
      scene_transition
    end

    private

    def scene_transition
      Scene.move_to(:opening) if Input.key_push?(K_RETURN)
    end

  end
end