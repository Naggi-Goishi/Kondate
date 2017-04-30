require_relative './column'
require_relative './action'

class Carousel
  def initialize(columns)
    @columns = columns
  end

  def build
    {
      "type": "template",
      "altText": "this is a carousel template",
      "template": {
          "type": "carousel",
          "columns": @columns.map { |column| column.build }
      }
    }
  end
end