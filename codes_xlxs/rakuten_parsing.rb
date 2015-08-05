require 'open-uri'
require 'nokogiri'
require 'open-uri'
require 'pry'


tickers = [1301, 1332, 1333, 1352, 1377, 1379, 1414, 1417, 1419, 1420, 1514]

rakuten_quote = Nokogiri::HTML(open("https://www.trkd-asia.com/rakutensec/quote.jsp?ric=1301.T&c=ja&ind=1"))

p "有利子負債 - 一年分"

p rakuten_quote.css('.tbl-data-01 tr')[25].css('td')
.text.gsub!(/[,]|[百万円]/, "").to_i * 1000000


p "株主持分"

p rakuten_quote.css('.tbl-data-01 tr')[21].css('td')
.text.gsub!(/[,]|[百万円]/, "").to_i * 1000000

p "会社概要"
p rakuten_quote.css('#segment > p').text

rakuten_profile = Nokogiri::HTML(open("https://www.trkd-asia.com/rakutensec/quote.jsp?ric=1301.T&c=ja&ind=2"))

prof_tbl = rakuten_profile.css('#str-main > table:nth-child(4)')

p "売上高 0 年"
p prof_tbl.css('.tbl-data-02 td')[3].text.gsub!(/[,]|[百万円]/, "").to_i

p "売上高 -1年"
p prof_tbl.css('.tbl-data-02 td')[2].text.gsub!(/[,]|[百万円]/, "").to_i

p "売上高 -2年"
p prof_tbl.css('.tbl-data-02 td')[1].text.gsub!(/[,]|[百万円]/, "").to_i

p "売上高 -3年"
p prof_tbl.css('.tbl-data-02 td')[0].text.gsub!(/[,]|[百万円]/, "").to_i


# "税引等調整前当期純利益 - 四年分"
# "研究開発"
# "現金"
# "減価償却"
