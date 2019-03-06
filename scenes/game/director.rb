module Game
  class Director
    def initialize
      #@bg_img = Image.load('images/opening_bg.png')   # 背景の設定
      @bg_img = Image.new(500, 650, color=C_RED)    # 背景の設定
      @font = Font.new(32)    # フォントの設定

      @space = CP::Space.new  # 物理演算空間を作成
      @space.gravity = CP::Vec2.new(10, 10)    # 物理演算空間に重力を設定(yを+方向に)

      #@circle = CPCircle.new(250-15, 450, 15, 1, C_BLUE, 0.9, 0.8)   # 剛体の円形を設定
      @current = CPCircle.new(250-15, 600, 15, 1, C_BLUE, 0.9, 0.8)   # 剛体の円形を設定
      #@circle.apply_force(100, -500)   # x方向のみに外力を設定

      @walls = CPBase.walls     # 剛体の壁を設定

      @power_bar_width = 10
      @power_v_size = 1
      @power_h_size = 1

      #@power_v = Image.new(@power_bar_width, @power_v_size, C_GREEN)
      #@power_h = Image.new(@power_h_size, @power_bar_width, C_GREEN)

      #@space.add(@circle)     # 重力空間に丸のやつを追加
      @space.add(@current)
      @walls.each do |wall|   # 壁を物理空間に追加
        @space.add(wall)
      end

      @start_time = Time.now    # 時間カウントを始める
      @limit = 10              # 制限時間の設定

      @push_count = 0

    end

    # main.rb側のWindow.loop内で呼ばれるメソッド
    def play
      #p @push_count
      Window.draw(0, 0, @bg_img)  # 背景の描画

      time = Time.now           # 現在の時間をtimeに格納
      limit_time = time - @start_time   # 経過時間を計算
      count = (@limit - limit_time).to_i  # 残り時間を計算し、int型に変換
      Window.draw_font(10, 10,"Time:#{count + 1}",@font)  # 残り時間を描画
      #Window.draw_font(340, 600, 'Push Space key to start', @font, color: C_RED)   # 文字を描画

      #@circle.draw      # 円の描画
      @current.draw

      @walls.each(&:draw)   # よくわからない。。。書かないと表示されない

      #p @push_count
      if @push_count == 0   # 一度だけよびだすやつ
        #クリック時のx,y座標
        start_shoot if Input.mouse_push?(M_LBUTTON)   # こっちでカウント++しちゃうと引っ張っている間もループ回ってるからifに入らなくなる
        #	@start_y = mouse_pos_y if Input.mouse_down?(M_LBUTTON)
        #クリック終了後のx,y座標
        #p @current
        #移動時(押されている間))
        move_shot if Input.mouse_down?(M_LBUTTON)
        if Input.mouse_release?(M_LBUTTON)
          last_shoot
          #start_time2 = Time.now    # 時間カウントを始める
          @push_count = 1
        end
      end

      if @current.body.pos.y <= 555    # 一定値より上に行ったら固定バーを復活
        @walls << CPStaticBox.new(0, 550, 500, 555)
        @space.add(CPStaticBox.new(0, 550, 500, 555))
      end

      """
      if limit_time % 10 >= -1 && limit_time % 10 <= 1
        @space.gravity = CP::Vec2.new(0, 500)    # 物理演算空間に重力を設定(yを+方向に)
      end
      """

      #p "x方向の速度" + @current.body.v.x + "　　y方向の速度" + @current.body.v.y
      if @current.body.v.x <= 100 && @current.body.v.x >= -100 && @current.body.v.y <= 100 && @current.body.v.y >= -100
        @current.body.v.x = 0
        @current.body.v.y = 0
        if @push_count == 1
          @current.body.v.y = 100
          @space.gravity = CP::Vec2.new(0, 300)    # 物理演算空間に重力を設定(yを+方向に)
        end
      end

      @space.step(1 / 60.0)    # Windowの生成速度は1/60なので、物理演算の仮想空間も同じように時間が進むようにする

      if count == 0
        scene_transition    # シーン遷移
      end

    end

    def options
      @options
    end

    def options=(value)
      @options = value
    end

    private

    def move_shot
      @move_x = Input.mouse_pos_x
      @move_y = Input.mouse_pos_y
      Window.draw_line(@start_x, @start_y, @move_x, @move_y, C_YELLOW, z=0)
    end

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
      #@circle.apply_force(@power_h_size * 2.5, -@power_v_size * 2.5)   # 
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
