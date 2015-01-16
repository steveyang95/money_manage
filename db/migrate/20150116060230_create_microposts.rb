class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, index: true
      t.decimal :deposit, :precision => 10, :scale => 5
      t.decimal :withdraw, :precision => 10, :scale => 5

      t.timestamps null: false
    end
    add_index :microposts, [:user_id, :created_at]
  end
end
