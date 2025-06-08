class CreateContents < ActiveRecord::Migration[8.0]
  def change
    create_table :contents do |t|
      t.references :site, null: false, foreign_key: true
      t.string :path, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
