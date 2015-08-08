require 'pry'



info = { year: 2015, corp_info: 'ニチダイグループは、同社と子会社のニチダイフィルタ、THAI SINTERED MESH CO.,LTD.、ニチダイプレシジョン、NICHIDAI(THAILAND)LTD.、NICHIDAI ASIA CO.,LTD.、NICHIDAI U.S.A. CORPORATIONの７社で構成される。ネットシェイプ事業は、自動車部品メーカーを中心とした、主に冷間鍛造に使用される精密鍛造金型等、エアコン用スクロールコンプレッサー部品、各種ギア等自動車部品等を提供する。アッセンブリ事業は、可変ジオメトリ（VG）ターボチャージャー部品等を提供する。フィルタ事業は、石油化学、医薬品、食品、原子力などの分野で使用される焼結金属フィルタ等を提供する。' }

hash1 = { 売上高: [12_525, 13_155, 14_272, 14_635], "支払利息 営業外": [-55, -41, -61, -51], "受取利息 営業外": [8, 5, 10, 9], "税引等調整前当期純利益 ": [838, 931, 1315, 1293], 研究開発: [0, 0, 0, 0], 現金: [1853, 1744, 2087, 2424], 減価償却: [-9042, -9361, -9641, -10_182] }
hash2 = [{ 有利子負債: 3490 }, { 株主持分: 9426 }]
array = [2012, 2013, 2014, 2015]

num_arr = []
hash1.each do |k, v|
  array.each do |num|
    v.each do |fin|
      ar1 = %w(yr num ent)
      ar2 = [num, k, fin]
      hash = {}
      ar1.zip(ar2).each { |key, value| hash[key] = value }
      num_arr << hash
    end
  end
end


p num_arr
