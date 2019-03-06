require_relative 'ball'
module Game
  class Director
    LIMIT_TIME = 60 #ゲームの制限時間を設定
    def initialize
      #@bg_img = Image.load('images/opening_bg.png')   # 背景の設定
      @bg_img = Image.new(500, 650, color=C_RED)    # 背景の設定
      @font = Font.new(32)    # フォントの設定

      @space = CP::Space.new  # 物理演算空間を作成
      @space.gravity = CP::Vec2.new(10, 10)    # 物理演算空間に重力を設定(yを+方向に)

      #@circle = CPCircle.new(250-15, 450, 15, 1, C_BLUE, 0.9, 0.8)   # 剛体の円形を設定
      @balls = [Ball.new(250-15, 600, 15, 1, C_BLUE, 0.9, 0.8)]    # 剛体の円形を設定
      #@circle.apply_force(100, -500)   # x方向のみに外力を設定

      @walls = CPBase.walls     # 剛体の壁を設定
      """
      @power_bar_width = 10
      @power_v_size = 1
      @power_h_size = 1
      """
      #@power_v = Image.new(@power_bar_width, @power_v_size, C_GREEN)
      #@power_h = Image.new(@power_h_size, @power_bar_width, C_GREEN)

      #@space.add(@circle)     # 重力空間に丸のやつを追加
      @balls.each { |ball| @space.add(ball) }
      @walls.each do |wall|   # 壁を物理空間に追加
        @space.add(wall)      # 壁を物理的に追加
      end

      # if Input.key_push?(K_RETURN)
      #   @start_time = Time.now    # 時間カウントを始める

      @limit = 60 * LIMIT_TIME             # フレーム数 * 制限時間

      #   @push_count = 0
      # end

    end

    # main.rb側のWindow.loop内で呼ばれるメソッド
    def play
      if Input.key_push?(K_SPACE)
        @balls << Ball.new(250-15, 600, 15, 1, C_BLUE, 0.9, 0.8)
      end
      @limit -= 1 #1フレームごとに－1する

      Window.draw(0, 0, @bg_img)  # 背景の描画
      Window.draw_font(10, 10,"Time:#{@limit / 60}",@font)  # 残り時間を描画

      @walls.each(&:draw)   # よくわからない。。。書かないと表示されない

      @balls.each do |ball|
        ball.move(ball)
        ball.draw
      end

      @space.step(1 / 60.0)    # Windowの生成速度は1/60なので、物理演算の仮想空間も同じように時間が進むようにする

      if @limit == 0
        scene_transition    # シーン遷移
      end

    end

    private

    def start_shoot
      @start_x = Input.mouse_pos_x    # インスタンス変数に格納
      @start_y = Input.mouse_pos_y    # インスタンス変数に格納
    end

    def last_shoot
      #p @current
      @last_x = Input.mouse_pos_x     # インスタンス変数に格納
      @last_y = Input.mouse_pos_y     # インスタンス変数に格納
      power_x = @start_x - @last_x    # x座標の変位を計算
      power_y = @last_y - @start_y    # y座標の変位を計算
      @power_v_size += power_y        # y方向の力を計算
      @power_h_size += power_x        # x方向の力を計算
      #p @current
      @current.apply_force(@power_h_size * 2.5, -@power_v_size * 2.5)   # 計算した外力を加える
      #@circle.apply_force(@power_h_size * 2.5, -@power_v_size * 2.5)
      #@circle.apply_force(100, -100)
      #@current.apply_force(100, -100)
      @power_h_size = 1   # x方向の外力の初期化
      @power_v_size = 1   # y方向の外力の初期化
    end

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
