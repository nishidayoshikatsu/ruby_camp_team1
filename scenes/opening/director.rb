module Opening
  class Director
    def initialize
      @bg_img = Image.load('images/opening.png')
    end

    def play
      Window.draw(0, 0, @bg_img)
      scene_transition
    end

    private

    def scene_transition
      Scene.move_to(:option) if Input.key_push?(K_RETURN)
      #Scene.move_to(:game) if Input.key_push?(K_RETURN)
    end
  end
end
