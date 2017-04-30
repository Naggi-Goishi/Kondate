class Action
  def initialize(type, label, data)
    @type =  type
    @label = label
    @data = data
  end

  def build
    case @type
    when 'postback'
      {
        "type": 'postback',
        "label": @label,
        "data": @data
      }
    when 'message'
    when 'uri'
      {
        "type": 'uri',
        "label": @label,
        "uri": @data
      }
    end
  end
end
