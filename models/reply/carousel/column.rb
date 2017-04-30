class Column
  def initialize(thumbnail_image_url, title, text, actions)
    @thumbnail_image_url =  thumbnail_image_url
    @title = title
    @text = text
    @actions = actions
  end

  def build
    {
      "thumbnailImageUrl": @thumbnail_image_url,
      "title": @title,
      "text": @text,
      "actions": @actions.map { |action| action.build }
    }
  end
end