require 'open-uri'
require 'nokogiri'
require 'pry'

class YahooParser
  attr_reader :ticker, :yahoo

  def initialize(ticker)
    @ticker = ticker
    @yahoo = Nokogiri::HTML(open("http://stocks.finance.yahoo.co.jp/stocks/detail/?code=#{ticker}.T"))
  end

  def ticker_matched?
    ticker == yahoo.at("#stockinf > div.stocksDtl.clearFix
                                  > div.forAddPortfolio > dl > dt").text.to_i
  end

  def get_data_hash
    if ticker_matched?
      {'時価総額': yahoo.css("#rfindex > div.chartFinance >
                                     div:nth-child(1) > dl > dd >
                                     strong").text.gsub!(/\,/, '').to_i,

       '発行済株式数': yahoo.css("#rfindex >
                                  div.chartFinance > div:nth-child(2) >
                                  dl > dd > strong").text.gsub!(/\,/, '')
       .to_i/1_000_000.round,

       'PER': yahoo.css("#rfindex > div.chartFinance > div:nth-child(5)
                                > dl > dd > strong")
       .text.gsub!(/\((連)\) /, '').to_f,

       'PBR': yahoo.css("#rfindex > div.chartFinance > div:nth-child(6)
                                > dl > dd > strong").text.gsub!(/\((連)\) /, '')
       .to_f,

       '前日終値': yahoo.css("#detail > div.innerDate > div:nth-child(1)
                                     > dl > dd > strong").text.to_i,

       '始値': yahoo.css("#detail > div.innerDate > div:nth-child(2)
                                 > dl > dd > strong").text.to_i,

       '現在値': yahoo.xpath("//td[@class='stoksPrice']").text.to_i,

       '会社名': yahoo.at("//th[@class='symbol']/h1").text.gsub!(/\((株)\)/, ''),

       'ticker': ticker}
    else
      raise "Ticker code didn't match. Check Yahoo page of #{ticker}."
    end
  end
end


# p YahooParser.new(1332).get_data_hash
# == {:時価総額=>115874, :発行済株式数=>277210277, :PER=>11.0, :PBR=>1.32, :前日終値=>423, :始値=>419, :現在値=>418, :会社名=>"日本水産", :ticker=>1332}
