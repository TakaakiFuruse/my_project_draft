require 'open-uri'
require 'nokogiri'
require 'pry'

class RakutenParser
  attr_reader :ticker_code
  attr_accessor :text_to_integer

  def initialize(ticker_code)
    @ticker_code = ticker_code
  end


  def build_hash
    {
      2015: {" ": , " ": ,}
      2014: {" ": , " ": ,}
      2013: {" ": , " ": ,}
    }
    fin_nums = {corp_info: corp_info,
                quote_table: quote_table,
                bs_table: bs_table,
                pl_table: pl_table}
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

  def pl_table
    pl_tbl = rakuten_prof_pl.css('#str-main > table:nth-child(4)').css('.tbl-data-02 td')
    pl_nums ={
      "売上高": pl_tbl[0..3].map(&:text),
      "支払利息 営業外": pl_tbl[104..107].map(&:text),
      "受取利息 営業外": pl_tbl[108..111].map(&:text),
      "税引等調整前当期純利益 ": pl_tbl[132..135].map(&:text),
      "研究開発": pl_tbl[72..75].map(&:text)
    }
  end


  def bs_table
    bs_tbl = rakuten_prof_bs.css('#str-main > table:nth-child(4)').css('.tbl-data-02 td')
    bs_nums= {
      "現金": bs_tbl[0..3].map(&:text),
      "減価償却": bs_tbl[60..63].map(&:text)
    }
  end


  def quote_table
    quote_nums = {
      "有利子負債": rakuten_quote.css('.tbl-data-01 tr')[25].css('td').text,
      "株主持分": rakuten_quote.css('.tbl-data-01 tr')[21].css('td').text
    }
  end

  def corp_info
    corp_info = {"会社概要": rakuten_quote.css('#segment > p').text}
  end

end


TICKERS = [6467]

TICKERS.each do |ticker|
  p RakutenParser.new(ticker).build_hash
end
