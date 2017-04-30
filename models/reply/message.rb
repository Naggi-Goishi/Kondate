class Message
  def initialize(text)
    @text = text
  end

  def build
    {
      type: 'text',
      text: @text
    }
  end
end