class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.integer :number
      t.integer :messages_count ,default: 0
      t.string :name
      t.references :app, foreign_key: true

      t.timestamps
    end
    add_index :chats, :number
  end
end
