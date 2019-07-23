class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.integer :number
      t.string :name
      t.text :body
      t.references :chat, foreign_key: true

      t.timestamps
    end
    add_index :messages, :number
  end
end
