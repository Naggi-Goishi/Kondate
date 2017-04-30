class AddThumbnailImageUrlToRecipes < ActiveRecord::Migration[5.1]
  def change
    add_column :recipes, :thumbnail_image_url, :string
  end
end
