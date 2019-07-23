class CreateApps < ActiveRecord::Migration[5.2]
  def change
    create_table :apps do |t|
      t.string :name
      t.string :token
      t.integer :chats_count ,default: 0

      t.timestamps
    end
    add_index :apps, :token, unique: true
  end
end
