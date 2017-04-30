class Action
  def initialize(type, label, data)
    @type =  type
    @label = label
    @data = data
  end

  def build
    case type
    when 'postback'
      {
        "type": @type,
        "label": @label,
        "data": @data
      }
    when 'message'
    when 'uri'
      {
        "type": @type,
        "label": @label,
        "uri": @data
      }
    end
  end
end
