class CreateSites < ActiveRecord::Migration[8.0]
  def change
    create_table :sites do |t|
      t.string :name, null: false
      t.string :description
      t.string :subdomain, null: false

      t.timestamps
    end

    add_index :sites, :subdomain, unique: true
  end
end
