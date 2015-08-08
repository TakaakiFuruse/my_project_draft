require 'open-uri'
require 'nokogiri'
require 'pry'

class RakutenParser
  attr_reader :ticker_code

  def initialize(ticker_code)
    @ticker_code = ticker_code
  end

  def build_info_hash
    corp_info
  end

  def build_multi_year_nums_hash
    num_arr = []
    multi_year_nums.each do |key, value|
      fiscal_year.each do |num|
        value.each do |fin|
          ar1 = ["year", "entry", "ammount"]
          ar2 = [num, key, fin]
          hash = {}
          ar1.zip(ar2).each{|k,v| hash[k] = v}
          num_arr << hash
        end
      end
    end
    num_arr
  end

  def build_single_year_nums_hash
    [
      {year: Time.now.strftime("%Y").to_i, entry: "有利子負債",
       ammount: to_int(quote_tbl[25].css('td'))},
      {year: Time.now.strftime("%Y").to_i, entry: "株主持分",
       ammount: to_int(quote_tbl[21].css('td'))}
    ]
  end

  def build_corp_info_hash
    corp_info = {year:  Time.now.strftime("%Y").to_i,
                 corp_info: rakuten_quote.css('#segment > p').text
                 }
  end

  private
  def fiscal_year
    year.css('tr')[0].css('th')[1..4].map{|n| to_int(n)}
  end


  def multi_year_nums
    {
      "売上高": pl_tbl[0..3].map{|n| to_int(n)},
      "支払利息 営業外": pl_tbl[104..107].map{|n| to_int(n)},
      "受取利息 営業外": pl_tbl[108..111].map{|n| to_int(n)},
      "税引等調整前当期純利益 ": pl_tbl[132..135].map{|n| to_int(n)},
      "研究開発": pl_tbl[72..75].map{|n| to_int(n)},
      "現金": bs_tbl[0..3].map{|n| to_int(n)},
      "減価償却": bs_tbl[60..63].map{|n| to_int(n)},
    }
  end



  def to_int(n)
    n.text.gsub(/\,|\-\-|[百万円]/, "").to_i
  end

  def rakuten_prof_pl
    Nokogiri::HTML(open("https://www.trkd-asia.com/rakutensec/quote.jsp?ric=#{ticker_code}.T&c=ja&ind=2"))
  end

  def rakuten_quote
    Nokogiri::HTML(open("https://www.trkd-asia.com/rakutensec/quote.jsp?ric=#{ticker_code}.T&c=ja&ind=1"))
  end

  def rakuten_prof_bs
    Nokogiri::HTML(open("https://www.trkd-asia.com/rakutensec/quote.jsp?ric=#{ticker_code}.T&c=ja&ind=2&fs=2"))
  end

  def year
    rakuten_prof_pl.css('#str-main > table:nth-child(4)')
  end

  def pl_tbl
    year.css('.tbl-data-02 td')
  end

  def bs_tbl
    rakuten_prof_bs.css('#str-main > table:nth-child(4)').css('.tbl-data-02 td')
  end

  def quote_tbl
    rakuten_quote.css('.tbl-data-01 tr')
  end


end


TICKERS = [6467]

TICKERS.each do |ticker|
  a = RakutenParser.new(ticker)
  p  a.build_corp_info_hash
  p a.build_single_year_nums_hash
  p a.build_multi_year_nums_hash
end
