require 'pry'

require 'roo'
require 'roo-xls'

XLS = ['first-d-j.xls',
       'first-f-j.xls',
       'second-d-j.xls',
       'second-f-j.xls',
       'mothers-d-j.xls',
       'mothers-f-j.xls',
       'jasdaq-g-j.xls',
       'jasdaq-s-j.xls',
       'jasdaq-f-j.xls']

codes = []

XLS.each do |xls|
  sheet = Roo::Spreadsheet.open(xls)
  codes << sheet.column(2)
end

codes.flatten!.delete('コード')
codes.map!(&:to_i)

p codes[0..10]
