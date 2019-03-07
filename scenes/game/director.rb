require_relative 'ball'
module Game
  class Director
    #attr_accessor :start_x
    #attr_accessor :start_y

    LIMIT_TIME = 60 #ゲームの制限時間を設定
    def initialize
      #@bg_img = Image.load('images/opening_bg.png')   # 背景の設定
      @bg_img = Image.new(500, 650, color=C_RED)    # 背景の設定
      @font = Font.new(32)    # フォントの設定

      @space = CP::Space.new  # 物理演算空間を作成
      @space.gravity = CP::Vec2.new(0, 0)    # 物理演算空間に重力を設定(yを+方向に)

      #@circle = CPCircle.new(250-15, 450, 15, 1, C_BLUE, 0.9, 0.8)   # 剛体の円形を設定
      @balls = [Ball.new(250-15, 600, 15, 1, C_BLUE, 0.9, 1)]    # 剛体の円形を設定
      #@circle.apply_force(100, -500)   # x方向のみに外力を設定

      @walls = CPBase.walls     # 剛体の壁を設定

      #@power_v = Image.new(@power_bar_width, @power_v_size, C_GREEN)
      #@power_h = Image.new(@power_h_size, @power_bar_width, C_GREEN)

      #@space.add(@circle)     # 重力空間に丸のやつを追加
      @balls.each { |ball| @space.add(ball) }
      @walls.each do |wall|   # 壁を物理空間に追加
        @space.add(wall)      # 壁を物理的に追加
      end

      #@start_x = 0
      #@start_y = 0

      @key_touch = 0

      @limit = 60 * LIMIT_TIME             # フレーム数 * 制限時間
    end

    # main.rb側のWindow.loop内で呼ばれるメソッド
    def play
      if Input.key_push?(K_SPACE) && @balls.all?{|ball| ball.on_stage == false}   # 全てのボールのon_stageフラグがfalseの時
        @balls << Ball.new(250-15, 600, 15, 1, C_BLUE, 0.9, 1)
        @key_touch += 1
      end
      @limit -= 1 #1フレームごとに－1する

      Window.draw(0, 0, @bg_img)  # 背景の描画
      Window.draw_font(10, 10,"Time:#{@limit / 60}",@font)  # 残り時間を描画

      @walls.each(&:draw)   # よくわからない。。。書かないと表示されない

      @balls.each do |ball|
        #puts ball
        ball.move
        ball.draw
        if ball.body.p.y <= 550    # 上のゾーンでしまる
          @walls << CPStaticBox.new(0, 550, 500, 555)
          @space.add(CPStaticBox.new(0, 550, 500, 555))
        end
      end
      """
      if @current.body.pos.y <= 555    # 臨時的な措置で5秒後に１番下がしまる
        @walls << CPStaticBox.new(0, 550, 500, 555)
        @space.add(CPStaticBox.new(0, 550, 500, 555))
      end
      """

      """
      puts @balls[0]
      puts @balls
      @balls[@key_touch].move(@balls[@key_touch])
      @ball[@key_touch].draw
      """

      # 1つのボールに対する処理が終了した段階で消すかどうかの判定
      """
      all_cnt = 0
      t_cnt = 0
      500.times do |i|
        30.times do |j|
          all_cnt += 1
          if Image.compare(i, j, color=C_BLUE)
            t_cnt += 1
          end
        end
      end
      # 横のラインがボールでどのくらい埋められているか
      if t_cnt / all_cnt >= 0.6

      end
      """

      @space.step(1 / 60.0)    # Windowの生成速度は1/60なので、物理演算の仮想空間も同じように時間が進むようにする

      if @limit == 0
        scene_transition    # シーン遷移
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
