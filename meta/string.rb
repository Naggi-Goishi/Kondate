class String
  AGENT = Mechanize.new

  def to_hiragana
    if hiragana?
      self
    elsif include_katakana?
      tr('ァ-ンヴ', 'ぁ-んゔ').to_hiragana
    elsif match('醬')
      gsub('醬', '醤').to_hiragana
    elsif include_alphabet?
      gsub(/[A-Za-z]/, '').to_hiragana
    elsif include_symbols?
      gsub(/・|\//, '').to_hiragana
    elsif match('ゔ')
      nil
    else
      AGENT.get('https://yomikatawa.com/kanji/' + self).search('#content p').first.try(:inner_text) if certain?
    end
  end

  def hiragana?
    match(/^[ぁ-んー・ゔ]+$/)
  end

  def include_katakana?
    match(/\p{Katakana}*\p{Katakana}/)
  end

  def include_alphabet?
    match(/[A-Za-z]*[A-Za-z]/)
  end

  def include_symbols?
    match(/・|\//)
  end

  def certain?
    AGENT.get('https://yomikatawa.com/kanji/' + self).search('.alert').empty?
  end
end