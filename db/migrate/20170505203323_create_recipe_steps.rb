class CreateRecipeSteps < ActiveRecord::Migration[5.1]
  def change
    create_table :recipe_steps do |t|
      t.integer :step_num
      t.string  :thumbnail_image_url
      t.text    :text
      t.references :recipe
    end
  end
end
