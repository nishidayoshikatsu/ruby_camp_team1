require_relative 'ball'
module Game
  class Director
    #attr_accessor :start_x
    #attr_accessor :start_y

    LIMIT_TIME = 100 #ゲームの制限時間を設定
    def initialize
      #@bg_img = Image.load('images/opening_bg.png')   # 背景の設定
      @bg_img = Image.new(500, 650, color=C_RED)    # 背景の設定
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

      @wall = CPStaticBox.new(0, 550, 500, 555)

      #@start_x = 0
      #@start_y = 0

      @image = Image.load('images/ruby_image.png')

      @obstacles = []
      5.times do
        x = rand(385) + 30
        y = rand(385) + 30
        obstacle = RubyStaticBox.new(x, y)
        @space.add(obstacle)
        @obstacles << obstacle
      end

      @key_touch = 0

      @limit = 60 * LIMIT_TIME             # フレーム数 * 制限時間
    end

    # main.rb側のWindow.loop内で呼ばれるメソッド
    def play
      if Input.key_push?(K_SPACE) && @balls.all?{|ball| ball.on_stage == false}   # 全てのボールのon_stageフラグがfalseの時
        #puts "flag全部falseだよ"
        @balls << Ball.new(250-50, 550, 35, 1, C_BLUE, 0.9, 1)
        @space.add(@balls.last)
        @key_touch += 1
        @walls.pop
        @space.remove(@wall)
      end
      @limit -= 1 #1フレームごとに－1する

      Window.draw(0, 0, @bg_img)  # 背景の描画
      Window.draw_font(10, 10,"Time:#{@limit / 60}",@font)  # 残り時間を描画

      @walls.each(&:draw)   # よくわからない。。。書かないと表示されない

      wind

      @balls.each do |ball|
        if @balls[@key_touch] ==  ball
          #puts "新しいボール指定"
          @balls[@key_touch].move
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


      # 1つのボールに対する処理が終了した段階で消すかどうかの判定

      all_cnt = 0
      t_cnt = 0
      500.times do |i|
        50.times do |j|
          all_cnt += 1
          if @balls#compare(i, j, color=[0,0, 255])
            #puts Image#compare(i, j, color=[0,0,0])
            t_cnt += 1
          end
        end
      end
      # 横のラインがボールでどのくらい埋められているか
      if t_cnt*1.0 / all_cnt >= 0.6
        puts t_cnt/all_cnt
        puts C_BLUE
        puts "うまったwww"
      end

      @space.step(1 / 60.0)    # Windowの生成速度は1/60なので、物理演算の仮想空間も同じように時間が進むようにする

      Scene.score = 100
      Window.draw_font(350, 10,"Score:#{Scene.score}",@font)  #スコアを表示

      if @limit == 0
        scene_transition    # シーン遷移
      end

    end

    def wind
      #@wind_name = "風"
      #風発生
      def wind_S_start
          @space.gravity = CP::Vec2.new(30, 0)
          @wind_name = "弱風"
      end
      def wind_M_start
          @space.gravity = CP::Vec2.new(70, 0)
          @wind_name = "中風"
      end
      def wind_L_start
          @space.gravity = CP::Vec2.new(100, 0)
          @wind_name = "強風"
      end

      #風を止ませる
      def wind_end
        @space.gravity = CP::Vec2.new(0, 0)
      end

      @wind_index= 100
      @wind_count = 0

      #40s ,30sの時に風を発生
      if @limit == 1800  || @limit  == 2400
        @wind_index = rand(6)
      end


      if 25 <= @limit / 60 && @limit / 60 < 30 || 35 <= @limit / 60 && @limit / 60 < 40
        Window.draw_font(10, 550,"#{@wind_name}発生中\n\n\n～～～～＞",@font)
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

      #25s, 35sの時に風を止ませる
      if @limit / 60 == 25 || @limit / 60 == 35
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
      Scene.move_to(:result)
    end

    """
    def scene_transition
      Scene.move_to(:ending) unless @current
    end
    """
  end
end
