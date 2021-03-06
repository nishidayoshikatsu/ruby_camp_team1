class Scene
  @@scenes = {}   # scenesにはハッシュを入れる  クラス変数

  @@current = nil

  def self.add(director, title)
    @@scenes[title.to_sym] = director   #titleをハッシュに変換したscenes要素にオブジェクトを設定
  end

  #def self.move_to(title)   # def self.move_to(title, opt={})
  def self.move_to(title, opt = nil)
    @@current = title.to_sym
    @@scenes[@@current].options = opt if opt
  end

  def self.play
    @@scenes[@@current].play
  end

  def self.score
    @@score
  end

  def self.score=(s)
    @@score = s
  end

end