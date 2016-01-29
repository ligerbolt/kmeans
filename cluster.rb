#coding utf-8
require "matrix"

# クラスタクラス
class Cluster

  # 識別用インデクス
  attr_accessor :index

  def initialize(vector, index)
    @belong_vectors = []
    @center = Vector.elements(vector)
    @index = index
  end

  # クラスタ-データ間距離算出
  def calc_distance(vector)
    distance = 0.0
    @center.each2(Vector.elements(vector)) { |x,y| distance += (x - y) ** 2 }
    distance
  end

  # クラスタ所属データ取得
  def set_vector(vector)
    @belong_vectors << vector
  end

  # クラスタ所属データ出力
  def get_vector
    @belong_vectors.each { |vector| p vector }
  end

  # クラスタセンター座標更新
  def update_center
    new_center =
      @belong_vectors.transpose.map { |val| val.inject(:+) / @belong_vectors.size }
    @center = Vector.elements(new_center)
  end

end
