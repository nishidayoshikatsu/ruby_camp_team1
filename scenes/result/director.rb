module Result
  class Director
    def initialize
      @bg_img = Image.load('./images/result.png')
      @font = Font.new(60)
      @sound = Sound.new("music/end.wav")
      @sound.loop_count = -1
      @start = 0
    end

    def play
      if @start == 0
        @sound.set_volume(255.0)#音の大きさ
        @sound.play
        @start += 1
      end
      Window.draw(0, 0, @bg_img)
      # Scene.score = 100
      Window.draw_font(300, 400, "#{Scene.score}", @font, color: C_RED)

    #   Window.draw_font(100, 400, 'Score:', @font, color: C_RED)
    #   Window.draw_font(100, 600, 'Push Enter key', @font, color: C_RED)
      scene_transition
    end

    private

    def scene_transition
      if Input.key_push?(K_RETURN)
        Scene.move_to(:opening)
        @sound.stop
      end
    end

  end
end