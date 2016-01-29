#coding utf-8
require_relative "cluster"

datasets = []
clusters = []

# クラスタリング対象データ取得
File::open("datasets.csv") do |file|
  file.each_line { |line| datasets << Dataset.new(line.split.map(&:to_f)) }
end

CLUSTER_COUNT = 3.freeze

# 初期クラスタ生成(ランダム選択したデータとする)
CLUSTER_COUNT.times do |i|
  rand_i = Random.rand(0..(datasets.size-1))
  clusters << Cluster.new(datasets[rand_i].vector, i)
end

loop_count = 1

# 結果が収束するまでクラスタリング処理実行
loop do
  calc_flag = false

  # 各クラスタとの距離算出
  datasets.each do |data|
    min_distance = min_cluster = ()
    clusters.each do |cluster|
      distance = cluster.calc_distance(data.vector)
      if min_distance.nil? || distance < min_distance
        min_distance = distance
        min_cluster = cluster
      end
    end

    # 所属（最近傍）クラスタ決定
    min_cluster.set_vector(data.vector)
    calc_flag = true if data.clstr_index != min_cluster.index
    data.clstr_index = min_cluster.index
  end

  # 計算終了判定
  break unless calc_flag

  # 各クラスタのセンター座標再算出
  clusters.each {|cluster| cluster.update_center }
  loop_count += 1
end

# クラスタリング結果出力
datasets.each do |data|
  puts "#{data.vector} : #{data.clstr_index}"
end
