class CreateRecipeKinds < ActiveRecord::Migration[5.1]
  def change
    create_table :recipe_kinds do |t|
      t.string :name
    end
  end
end
