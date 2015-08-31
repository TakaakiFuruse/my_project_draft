require 'open-uri'
require 'nokogiri'
require 'pry'

class RakutenParser
  # TICKERS = [6467,1384]
  # TICKERS.each do |ticker|
  #   a = RakutenParser.new(ticker)
  #   a.build_entry_nums_hash
  #   a.build_single_year_nums_hash
  #   a.build_corp_info_hash
  # end
  # will return each infos in hash

  attr_reader :ticker_code, :key_array, :rakuten_quote, :rakuten_prof_pl, :rakuten_prof_bs, :entry_headers, :rakuten_prof_cs

  def initialize(ticker_code)
    @ticker_code = ticker_code
    @key_array = %w(year entry amount)
    @entry_headers = ['売上高', '支払利息 営業外', '受取利息 営業外',
                      '税引等調整前当期純利益', '研究開発', '現金',  '減価償却']
    @rakuten_quote = Nokogiri::HTML(open("https://www.trkd-asia.com/rakutensec/quote.jsp?ric=#{ticker_code}.T&c=ja&ind=1"))
    @rakuten_prof_pl = Nokogiri::HTML(open("https://www.trkd-asia.com/rakutensec/quote.jsp?ric=#{ticker_code}.T&c=ja&ind=2"))
    @rakuten_prof_bs = Nokogiri::HTML(open("https://www.trkd-asia.com/rakutensec/quote.jsp?ric=#{ticker_code}.T&c=ja&ind=2&fs=2"))
    @rakuten_prof_cs = Nokogiri::HTML(open("https://www.trkd-asia.com/rakutensec/quote.jsp?ric=#{ticker_code}.T&c=ja&ind=2&fs=3"))

    entry_checker
  end

  def build_entry_nums_hash
    entry_nums.flat_map do |num_key, num_val_arr|
      fiscal_year.map.with_index do |year, i|
        { ticker: ticker_code,
          year: year,
          entry: num_key.to_s,
          amount: num_val_arr[i] }
      end
    end
  end

  def build_single_year_nums_hash
    [
      { ticker: ticker_code,
        year: Time.now.strftime('%Y').to_i, entry: '有利子負債',
        amount: to_int(quote_tbl[25].css('td'))},
      { ticker: ticker_code,
        year: Time.now.strftime('%Y').to_i, entry: '純資産',
        amount: to_int(quote_tbl[20].css('td'))},
      { ticker: ticker_code,
        year: Time.now.strftime('%Y').to_i, entry: '株主持分',
        amount: to_int(quote_tbl[21].css('td'))}
    ]
  end

  def build_corp_info_hash
    { ticker: ticker_code,
      year:  Time.now.strftime('%Y').to_i,
      corp_info: rakuten_quote.css('#segment > p').text
      }
  end

  def entry_checker
    if check_hash.has_value?(false)
      check_hash.each{|k,v| puts "#{k}: #{v}"}
      fail "Entries didn't matched! Check #{ticker_code} on rakuten."
    end
  end

  private

  def check_hash
    # String中のスペースは故意に入れてあるので消さないこと
    {"売上高": '    売上高' == year.css('.tbl-data-02 th')[6].text,
     '支払利息（営業外）': '支払利息（営業外）' == year.css('.tbl-data-02 th')[31].text,
     '受取利息（営業外）': '受取利息（営業外）' == year.css('.tbl-data-02 th')[32].text,
     '税引等調整前当期純利益': '税引等調整前当期純利益' == year.css('.tbl-data-02 th')[38].text,
     '研究開発費': '研究開発費' == year.css('.tbl-data-02 th')[23].text,
     '現金・短期投資': '現金・短期投資' == bs_entry.css('.tbl-data-02 th')[5].text,
     "有形固定資産の減価償却費": "    有形固定資産の減価償却費" == cs_tbl.css('tr')[3].css('th').text,
     "無形固定資産の償却費": "    無形固定資産の償却費" == cs_tbl.css('tr')[4].css('th').text,
     "有利子負債": "有利子負債" == quote_tbl[25].css('th').text,
     "純資産": "純資産" ==  quote_tbl[20].css('th').text,
     "株主持分": "株主持分" ==  quote_tbl[21].css('th').text
     }
  end

  def entry_nums
    {"売上高": pl_tbl[0..3].map { |n| to_int(n) },
     "支払利息_営業外": pl_tbl[104..107].map { |n| to_int(n) },
     "受取利息_営業外": pl_tbl[108..111].map { |n| to_int(n) },
     "税引等調整前当期純利益": pl_tbl[132..135].map { |n| to_int(n) },
     "研究開発": pl_tbl[72..75].map { |n| to_int(n) },
     "現金": bs_tbl[0..3].map { |n| to_int(n) },
     "有形固定資産の減価償却費": cs_tbl.css('tr')[3].css('td').map { |n| to_int(n) },
     "無形固定資産の償却費": cs_tbl.css('tr')[4].css('td').map { |n| to_int(n) }
     }
  end

  def fiscal_year
    year.css('tr')[0].css('th')[1..4].map { |n| to_int(n) }
  end

  def to_int(n)
    n.text.gsub(/\,|\-\-|[百万円]/, '').to_i
  end

  def year
    rakuten_prof_pl.css('#str-main > table:nth-child(4)')
  end

  def pl_tbl
    year.css('.tbl-data-02 td')
  end

  def cs_tbl
    rakuten_prof_cs.css('table:nth-child(4)')
  end

  def bs_tbl
    rakuten_prof_bs.css('#str-main > table:nth-child(4)').css('.tbl-data-02 td')
  end

  def bs_entry
    rakuten_prof_bs.css('#str-main > table:nth-child(4)')
  end

  def quote_tbl
    rakuten_quote.css('.tbl-data-01 tr')
  end
end
