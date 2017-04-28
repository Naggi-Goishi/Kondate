class RenameRecipeKindsIdToRecipeKindId < ActiveRecord::Migration[5.1]
  def change
    rename_column :recipes, :recipe_kinds_id, :recipe_kind_id
  end
end
