class CreateSourceTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :source_types do |t|
      t.string :title
    end
  end
end
