class CreateIngredientsRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :ingredients_recipes do |t|
      t.references :ingredient
      t.references :recipe
    end
  end
end
