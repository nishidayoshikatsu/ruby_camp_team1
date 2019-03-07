module Opening
  class Director
    def initialize
      @bg_img = Image.load('images/opening.png')
      @sound = Sound.new("music/opening.wav")
      @sound.loop_count = -1
      @start = 0
    end

    def play
      if @start == 0
        @sound.set_volume(255.0)#音の大きさ
        @sound.play
        @start += 1
        puts "music"
      end
      Window.draw(0, 0, @bg_img)
      scene_transition
    end

    private

    def scene_transition
      if Input.key_push?(K_RETURN)
        Scene.move_to(:option)
        @sound.stop
      end
    end
  end
end
