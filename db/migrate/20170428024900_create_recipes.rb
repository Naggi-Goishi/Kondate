class CreateRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :url
      t.string :thumbnail_image_url
      t.references :recipe_kind
    end
  end
end
