require 'open-uri'
require 'nokogiri'
require 'open-uri'
require 'pry'


tickers = [6467]
# , 1332, 1333, 1352]

tickers.each do |ticker|
  ticker
  rakuten_quote = Nokogiri::HTML(open("https://www.trkd-asia.com/rakutensec/quote.jsp?ric=#{ticker}.T&c=ja&ind=1"))

  p "有利子負債 - 一年分"

  p rakuten_quote.css('.tbl-data-01 tr')[25].css('td')
  .text.gsub!(/[,]|[百万円]/, "").to_i * 1_000_000


  p "株主持分"

  p rakuten_quote.css('.tbl-data-01 tr')[21].css('td')
  .text.gsub!(/[,]|[百万円]/, "").to_i * 1_000_000

  p "会社概要"
  p rakuten_quote.css('#segment > p').text

  rakuten_profile = Nokogiri::HTML(open("https://www.trkd-asia.com/rakutensec/quote.jsp?ric=#{ticker}.T&c=ja&ind=2"))

  prof_tbl = rakuten_profile.css('#str-main > table:nth-child(4)').css('.tbl-data-02 td')

  p "売上高 0 年"
  p prof_tbl[3].text.gsub!(/[,]|[百万円]/, "").to_i

  p "売上高 -1年"
  p prof_tbl[2].text.gsub!(/[,]|[百万円]/, "").to_i

  p "売上高 -2年"
  p prof_tbl[1].text.gsub!(/[,]|[百万円]/, "").to_i

  p "売上高 -3年"
  p prof_tbl[0].text.gsub!(/[,]|[百万円]/, "").to_i

  ##### 税引等調整前当期純利益 + 支払利息 - 受取利息 ######

  p "支払利息 営業外 0"
  p prof_tbl[107].text

  p "支払利息 営業外 -1"
  p prof_tbl[106].text

  p "支払利息 営業外 -2"
  p prof_tbl[105].text

  p "支払利息 営業外 -3"
  p prof_tbl[104].text

  p "受取利息 営業外 0"
  p prof_tbl[111].text
  p "受取利息 営業外 -1"
  p prof_tbl[110].text
  p "受取利息 営業外 -2"
  p prof_tbl[109].text
  p "受取利息 営業外 -3"
  p prof_tbl[108].text

  p "税引等調整前当期純利益 0年"
  p prof_tbl[135].text

  p "税引等調整前当期純利益 -1年"
  p prof_tbl[134].text

  p "税引等調整前当期純利益 -2年"
  p prof_tbl[133].text

  p "税引等調整前当期純利益 -3年"
  p prof_tbl[132].text
end

# ticker = 6467
# rakuten_profile = Nokogiri::HTML(open("https://www.trkd-asia.com/rakutensec/quote.jsp?ric=#{ticker}.T&c=ja&ind=2"))

# prof_tbl = rakuten_profile.css('#str-main > table:nth-child(4)').css('.tbl-data-02 td')

# p "研究開発"
# p "現金"
# p "減価償却"
