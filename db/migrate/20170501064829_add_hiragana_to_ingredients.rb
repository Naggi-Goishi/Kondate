class AddHiraganaToIngredients < ActiveRecord::Migration[5.1]
  def change
    add_column :ingredients, :hiragana, :string
  end
end
