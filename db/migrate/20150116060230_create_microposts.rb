class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, index: true
      t.integer :deposit
      t.integer :withdraw

      t.timestamps null: false
    end
    add_index :microposts, [:user_id, :created_at]
  end
end
