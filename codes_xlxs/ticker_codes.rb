require 'pry'
require 'roo'
require 'roo-xls'

class TickerCodeExtractor
  attr_accessor :codes

  def initialize
    @codes = []
    @xls = xls
    extract_code
  end

  def xls
    ['first-d-j.xls',
     'first-f-j.xls',
     'second-d-j.xls',
     'second-f-j.xls',
     'mothers-d-j.xls',
     'mothers-f-j.xls',
     'jasdaq-g-j.xls',
     'jasdaq-s-j.xls',
     'jasdaq-f-j.xls']
  end

  def read_xls
    xls.each do |xls|
      sheet = Roo::Spreadsheet.open(xls)
      codes << sheet.column(2)
    end
    codes.flatten!
  end

  def extract_code
    read_xls
    codes.delete("コード")
    codes.map!(&:to_i)
  end

end

# p TickerCodeExtractor.new.codes[0..10] == [1301, 1332, 1333, 1352, 1377, 1379, 1414, 1417, 1419, 1420, 1514]
