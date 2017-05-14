class String
  AGENT = Mechanize.new

  def to_hiragana
    if hiragana?
      self
    elsif match? (/[ァ-ンヴﾌﾞﾌﾗｯｸﾍﾟｯﾊﾟﾄﾏﾄｹﾁｬﾁｮｺﾚﾄｻｲﾞﾊﾟﾝ]/)
      tr('ァ-ンヴﾌﾗｯｸﾍﾟｯﾊﾟﾄﾏﾄｹﾁｬﾁｮｺﾚﾄｻｲﾞﾊﾟﾝ', 'ぁ-んゔぶらっくぺっぱとまとけちゃちょこれとさいぱん').to_hiragana
    elsif match? ('醬')
      gsub('醬', '醤').to_hiragana
    elsif match? ('麵')
      gsub('麵', '麺').to_hiragana
    elsif match? ('榨')
      gsub('榨', '搾').to_hiragana
    elsif match(/[-－―ｰ]/)
      gsub(/[-－―ｰ]/, 'ー').to_hiragana
    elsif match? ('〆')
      gsub('〆', 'しめ').to_hiragana
    elsif include_alphabet?
      gsub(/[A-Za-z]/, '').to_hiragana
    elsif include_symbols?
      gsub(/[\[\]ｘｔｒａ▪<>（）＜＞・\/,、ｂｍＯＬⅬＣＩＭＥＶＸＰＡＢＳ」'･◾︎◆│「０１２３４５６７８９％①②③④⑤⑥⑦⑧⑨⑩。&＆【】◾️★／]/i, '').to_hiragana
    elsif match('ゔ')
      nil
    else
      AGENT.get('https://yomikatawa.com/kanji/' + self).search('#content p').first.try(:inner_text) if certain?
    end
  end

  def hiragana?
    match(/^[ぁ-んー・ゔ]+$/)
  end

  def include_alphabet?
    match(/[A-Za-z]*[A-Za-z]/)
  end

  def include_symbols?
    match(/[\[\]ｘｔｒａ<>▪＜＞（）・\/,、ｂｍＯＬⅬＣＥＭＩＶＸＰＡＢＳ」'･◾︎◆│「０１２３４５６７８９％①②③④⑤⑥⑦⑧⑨⑩。&＆【】◾️★／]/i)
  end

  def certain?
    AGENT.get('https://yomikatawa.com/kanji/' + self).search('.alert').empty?
  end
end