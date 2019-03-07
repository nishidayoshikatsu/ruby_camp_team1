class Ball < CPCircle
    attr_accessor :on_stage   # 呼び出しているクラスからメソッドみたいによびだせるシンボル
    attr_accessor :coordinate

    def move(coordinate)
      #@push_count = 0
      @power_bar_width = 10
      @power_v_size = 1
      @power_h_size = 1

      puts @body.p
      puts @body.v

      if @body.p.x < 0 || @body.p.x > 500 #ボールがフィールド外に出るとresult画面に遷移
        Scene.move_to :result
        # puts "gameover"
        $soundp.stop
      end

      if @body.p.y > 500
        puts @body.v.x
        puts @body.v.y
        puts "スタートゾーン"
        #クリック時のx,y座標
        start_shoot if Input.mouse_push?(M_LBUTTON)   # こっちでカウント++しちゃうと引っ張っている間もループ回ってるからifに入らなくなる
        move_shot if Input.mouse_down?(M_LBUTTON)#カーソル移動時
        #puts "start_shoot"
        #	@start_y = mouse_pos_y if Input.mouse_down?(M_LBUTTON)
        #クリック終了後のx,y座標
        if Input.mouse_release?(M_LBUTTON)
          last_shoot(self)
        end
      else
        puts "こっちに入ってる？"
        @on_stage = true
        if @body.v.x <= 100 && @body.v.x >= -100 && @body.v.y <= 100 && @body.v.y >= -100
          #puts "はいったよ"
          @body.v.x = 0
          @body.v.y = 90
          @on_stage = false
        else
          @body.v.x -= 5        #ボールの速さを遅くする
          puts "xの成分-5してる"
          @body.v.y += 5
          puts "yの成分-5してる"
        end
      end
      #p @on_stage
    end

    def other_move    # 他の物体は固定
      puts "other_move"
      @body.v.x = 0
      @body.v.y = 0
    end

    def move_shot
      @move_x = Input.mouse_pos_x
      @move_y = Input.mouse_pos_y
      # Window.draw_line(@start_x, @start_y, @move_x, @move_y, C_YELLOW, z = 0)
      Window.draw_line(235, 585, 250 + @start_x - @move_x, 615 + @start_y - @move_y, C_YELLOW, z = 0)
    end

    def start_shoot
      puts "startはいるよ"
      @start_x = Input.mouse_pos_x    # インスタンス変数に格納
      @start_y = Input.mouse_pos_y    # インスタンス変数に格納
    end

    def last_shoot(ball)
      #p @current
      puts "発射するぞ"
      @last_x = Input.mouse_pos_x     # インスタンス変数に格納
      @last_y = Input.mouse_pos_y     # インスタンス変数に格納
      power_x = @start_x - @last_x    # x座標の変位を計算
      power_y = @last_y - @start_y    # y座標の変位を計算
      @power_v_size += power_y * 5   # y方向の力を計算
      @power_h_size += power_x * 5   # x方向の力を計算
      #p @current
      ball.apply_force(@power_h_size * 2.5, -@power_v_size * 2.5)   # 計算した外力を加える
      #@circle.apply_force(@power_h_size * 2.5, -@power_v_size * 2.5)
      #@circle.apply_force(100, -100)
      #@current.apply_force(100, -100)
      @power_h_size = 1   # x方向の外力の初期化
      @power_v_size = 1   # y方向の外力の初期化
    end
end
