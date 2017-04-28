class AddRecipeKindIdToRecipe < ActiveRecord::Migration[5.1]
  def change
    add_reference :recipes, :recipe_kinds
  end
end
