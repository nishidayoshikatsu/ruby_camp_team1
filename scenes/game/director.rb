require_relative 'ball'
module Game
  class Director
    #attr_accessor :start_x
    #attr_accessor :start_y

    LIMIT_TIME = 100 #ゲームの制限時間を設定

    def initialize
      #@bg_img = Image.load('images/opening_bg.png')   # 背景の設定
      @bg_img = Image.new(500, 650, color=C_GREEN)    # 背景の設定
      @font = Font.new(32)    # フォントの設定

      @space = CP::Space.new  # 物理演算空間を作成
      @space.gravity = CP::Vec2.new(0, 0)    # 物理演算空間に重力を設定(yを+方向に)

      #@circle = CPCircle.new(250-15, 450, 15, 1, C_BLUE, 0.9, 0.8)   # 剛体の円形を設定
      @balls = [Ball.new(250-50, 550, 35, 1, C_BLUE, 0.9, 1)]    # 剛体の円形を設定
      #@circle.apply_force(100, -500)   # x方向のみに外力を設定

      @walls = CPBase.walls     # 剛体の壁を設定

      #@power_v = Image.new(@power_bar_width, @power_v_size, C_GREEN)
      #@power_h = Image.new(@power_h_size, @power_bar_width, C_GREEN)

      #@space.add(@circle)     # 重力空間に丸のやつを追加
      @balls.each { |ball| @space.add(ball) }
      @walls.each do |wall|   # 壁を物理空間に追加
        @space.add(wall)      # 壁を物理的に追加
      end

      $soundp = Sound.new("music/game.wav")
      $soundp.loop_count = -1
      @start = 0

      @wall = CPStaticBox.new(0, 550, 500, 555)

      #@start_x = 0
      #@start_y = 0

      @image = Image.load('images/ruby_image.png')

      @obstacles = []
      5.times do
        x = rand(250) + 50
        y = rand(320) + 50
        obstacle = RubyStaticBox.new(x, y)
        @space.add(obstacle)
        @obstacles << obstacle
      end

      $point_cnt = []

      @key_touch = 0

      @limit = 60 * LIMIT_TIME             # フレーム数 * 制限時間
    end

    # main.rb側のWindow.loop内で呼ばれるメソッド
    def play
      if @start == 0
        $soundp.set_volume(255.0)#音の大きさ
        $soundp.play
        @start += 1
        puts "hellomusic"
      end

      if Input.key_push?(K_SPACE) && @balls.all?{|ball| ball.on_stage == false}   # 全てのボールのon_stageフラグがfalseの時
        if @balls.length >= 3
          @balls.delete_at(0)
          @space.remove(@balls[0])
          @balls.delete_at(0)
          @space.remove(@balls[0])
          @key_touch -= 1
          @key_touch -= 1
        end
        """
        i = 0
        puts @balls.length
        if @balls.length >= 2
          @balls.each do |ball|   # ボールの削除
            if ball.body.p.y >=450 && ball.body.p.y <= 530
              $point_cnt << i
              i += 1
            end
            puts ball.body.p
          end
          $point_cnt.pop
          puts $point_cnt

          j = 0
          if $point_cnt.length >= 2
            $point_cnt.each do |cnt|
              puts cnt
              puts @balls[cnt].body.p
              @balls.delete_at(0)
              @space.remove(@balls[0])
              puts @balls.length
              Window.draw_font(100, 580,削除！！！,@font)
              @key_touch -= 1
            end
          end
          $point_cnt = []
        end
        """

        @balls << Ball.new(250-50, 550, 35, 1, C_BLUE, 0.9, 1)
        @space.add(@balls.last)
        @key_touch += 1
        @walls.pop
        @space.remove(@wall)

      end
      @limit -= 1 #1フレームごとに－1する

      Window.draw(0, 0, @bg_img)  # 背景の描画
      Window.draw_font(10, 10,"Time:#{@limit / 60}",@font, {:color => [255,0, 0]})  # 残り時間を描画
      puts $point_cnt
      @walls.each(&:draw)   # よくわからない。。。書かないと表示されない

      wind    # 障害物発生のメソッド

      @balls.each do |ball|
        if @balls[@key_touch] ==  ball

          #puts "新しいボール指定"
          @balls[@key_touch].move(@coordinate)
          @balls[@key_touch].draw

          if @balls[@key_touch].body.p.y <= 550    # 上のゾーンでしまる
            @space.add(@wall) unless @walls[3]
            @walls[3] = @wall
            #puts @walls
            #if Input.key_push?(K_SPACE) == false
            #  @walls.pop()
            #end
          end
        else
          ball.other_move
          ball.draw
        end
      end

      @space.step(1 / 60.0)    # Windowの生成速度は1/60なので、物理演算の仮想空間も同じように時間が進むようにする

      Scene.score = 100
      Window.draw_font(350, 10,"Score:#{Scene.score}",@font, {:color => [255,0, 0]})  #スコアを表示

      if @limit == 0
        $soundp.stop
        scene_transition    # シーン遷移
      end
    end

    def wind
      #@wind_name = "風"
      #風発生
      def wind_S_start
          @space.gravity = CP::Vec2.new(30, 0)
          @wind_name = "風(弱)"
      end
      def wind_M_start
          @space.gravity = CP::Vec2.new(70, 0)
          @wind_name = "風(中)"
      end
      def wind_L_start
          @space.gravity = CP::Vec2.new(100, 0)
          @wind_name = "風(強)"
      end

      #風を止ませる
      def wind_end
        @space.gravity = CP::Vec2.new(0, 0)
      end

      @wind_index= 100
      @wind_count = 0

      #40s ,30sの時に風を発生
      if @limit == 1800  || @limit  == 3600
        @wind_index = rand(6)
      end

      if 20 <= @limit / 60 && @limit / 60 < 30 || 50 <= @limit / 60 && @limit / 60 < 60
        Window.draw_font(30, 580,"#{@wind_name}発生中\n\n\n～～～～＞",@font)
        #Window.draw_font(150, 150,"～～～～＞",@font)
      end

      while @wind_count != 300
        if @wind_index <= 2
    #			Window.draw_font(100, 100,"風発生中\n\n\n～～～～＞",@font)
    #			Window.draw_font(150, 150,"～～～～＞",@font)
          wind_S_start
        elsif @wind_index <= 4
    #			Window.draw_font(100, 100,"中風発生中\n\n\n～～～～＞",@font)
    #			Window.draw_font(150, 150,"～～～～＞",@font)
          wind_M_start
        elsif @wind_index == 5
    # 			Window.draw_font(100, 100,"強風発生中\n\n\n～～～～＞",@font)
    #			Window.draw_font(150, 150,"～～～～＞",@font)
          wind_L_start
        end
        @wind_count += 1
      end


      #20sと50sの時に風を停止
      # limitわざわざ60かけたのは単なるバグ
      if @limit / 60 == 20 || @limit / 60 == 50
        wind_end
      end

      #オブジェクト発生
      def make_obstacles
        @obstacles.each do|o|
          o.draw
        end
      end

      if @limit / 60
        make_obstacles
      end
    end

    private

    def scene_transition
      $soundp.stop
      Scene.move_to(:result)
    end

    """
    def scene_transition
      Scene.move_to(:ending) unless @current
    end
    """
  end
end
