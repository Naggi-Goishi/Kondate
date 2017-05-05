class AddMainToIngredientsRecipes < ActiveRecord::Migration[5.1]
  def change
    add_column :ingredients_recipes, :main, :boolean
  end
end
