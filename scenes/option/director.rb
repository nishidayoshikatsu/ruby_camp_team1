module Option
  class Director
    def self.options
      @@options
    end

    def self.options=(value)
      @@options = value
    end

    def initialize
       @background_color =  Image.load("./yellow.png")
       @font = Font.new(40)
       @font1 = Font.new(20)
       #@sound = Sound.new("button84.wav")
       @h1 = {:x => 50, :y => 200,:label => "速度:",:font => @font}
       @h2 = {:x => 50, :y => 300,:label => "物体の種類:",:font => @font}
       @h3 = {:x => 170, :y => 200,:label => "低速",:font => @font}
       @h4 = {:x => 270, :y => 200,:label => "普通",:font => @font}
       @h5 = {:x => 370, :y => 200,:label => "高速",:font => @font}
       @h6 = {:x => 370, :y => 300,:label => "円",:font => @font}
       @h7 = {:x => 270, :y => 300,:label => "四角",:font => @font}
     end

     def play
       h = Hash.new
       Window.draw(0, 0, image)
       Window.draw_font(0, 0, "戻る", font1, color: [255, 0, 0])

       def draw_option(x, y, label,font)
         Window.draw_font(x, y, label,font,color: [0, 0, 0])
       end

       [@h1,@h2,@h3,@h4,@h5,@h6,@h7].each do |hash|
           draw_option(hash[:x],hash[:y],hash[:label],hash[:font])
        end
        # x = 0
        #while x == 0
        #slow
        x = 0
        if Input.mouse_push?(M_LBUTTON) && Input.mouse_x >= 150 && Input.mouse_x <= 250 && Input.mouse_y >= 150 && Input.mouse_y <= 220
          sound.play
          x = 1
          speed = :slow
        end
        #normal
        if Input.mouse_push?(M_LBUTTON) && Input.mouse_x >= 251 && Input.mouse_x <= 320 && Input.mouse_y >= 150 && Input.mouse_y <= 220
          sound.play
          x = 1
          speed = :normal
        end
        #fast
        if Input.mouse_push?(M_LBUTTON) && Input.mouse_x >= 350 && Input.mouse_x <= 450 && Input.mouse_y >= 150 && Input.mouse_y <= 220
          sound.play
          x = 1
          speed = :fast
        end
        #end

        #while x == 1
        #circle
        if Input.mouse_push?(M_LBUTTON) && Input.mouse_x >= 350 && Input.mouse_x <= 420 && Input.mouse_y >= 280 && Input.mouse_y <= 350
          sound.play
          y = 1
          shape = :circle
        end
        #square
        if Input.mouse_push?(M_LBUTTON) && Input.mouse_x >= 250 && Input.mouse_x <= 320 && Input.mouse_y >= 280 && Input.mouse_y <= 350
          sound.play
          y = 1
          shape = :square
         end
        #end

        if x == 1 && y == 1
          h[:speed],h[:shape] = speed, shape
          @@options = h
        end
      end

      def scene_transition
        Scene.move_to(:opening) if Input.mouse_push?(M_LBUTTON) && Input.mouse_x >= 0 && Input.mouse_x <= 20 && Input.mouse_x >= 0 && Input.mouse_x <= 20
        Scene.move_to(:game, @@options) if x == 1 && y == 1
      end
  end
end