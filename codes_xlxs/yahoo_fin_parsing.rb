require 'open-uri'
require 'nokogiri'
require 'open-uri'
require 'pry'


tickers = [6467]
# , 1301, 1332, 1333, 1352, 1377, 1379, 1414, 1417, 1419, 1420, 1514]

tickers.each do |ticker|
  yahoo = Nokogiri::HTML(open("http://stocks.finance.yahoo.co.jp/stocks/detail/?code=#{ticker}.T"))

  puts "時価総額"
  p yahoo.css("#rfindex > div.chartFinance
             > div:nth-child(1) > dl > dd > strong").text.gsub!(/\,/,'').to_i

  puts "発行済株式数"
  p yahoo.css("#rfindex > div.chartFinance > div:nth-child(2)
             > dl > dd > strong").text.gsub!(/\,/,'').to_i

  puts "PER"
  p yahoo.css("#rfindex > div.chartFinance > div:nth-child(5)
             > dl > dd > strong").text.gsub!(/\((連)\) /, "").to_f

  puts "PBR"
  p yahoo.css("#rfindex > div.chartFinance > div:nth-child(6)
             > dl > dd > strong").text.gsub!(/\((連)\) /, "").to_f

  puts "前日終値"
  p yahoo.css("#detail > div.innerDate
            > div:nth-child(1) > dl > dd > strong").text.to_i

  puts "始値"
  p yahoo.css("#detail > div.innerDate
            > div:nth-child(2) > dl > dd > strong").text.to_i

  puts "現在値"
  p yahoo.xpath("//td[@class='stoksPrice']").text.to_i

  puts "会社名"
  p yahoo.at("//th[@class='symbol']/h1").text
  puts "========================================="


end
