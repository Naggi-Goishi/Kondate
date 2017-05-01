class Ingredients < ActiveRecord::Relation

  def initialize(ingredients)
    @records = ingredients
  end

  def hiraganas
    @records.group_by(&:hiragana).keys
  end

  def [](num)
    @records[num]
  end

  def blank?
    @records.blank?
  end

  def show
    return false if blank?
    (@records.inject("レシピ\n") { |text, ingredient| text + '・' + ingredient.name }).chomp
  end

  def inspect
    entries = @records[0..10]
    entries[10] = "..." if entries.size > 10
    "#<#{self.class.name} [#{entries.map(&:inspect).join(', ')}]>"
  end

  def include?(ingredient)
    @records.any? { |record| record == ingredient || record.eq_name?(ingredient) || record.eq_hiragana?(ingredient) }
  end
end