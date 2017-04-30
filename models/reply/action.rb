class Action
  def initialize(type, label, data)
    @type =  type
    @label = label
    @data = data
  end

  def build
    {
      "type": @type,
      "label": @label,
      "data": @data
    }
  end
end