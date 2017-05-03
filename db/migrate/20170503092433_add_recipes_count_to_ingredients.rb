class AddRecipesCountToIngredients < ActiveRecord::Migration[5.1]
  def change
    add_column :ingredients, :recipes_count, :integer
  end
end
