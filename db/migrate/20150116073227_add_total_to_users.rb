class AddTotalToUsers < ActiveRecord::Migration
  def change
    add_column :users, :total, :decimal, :precision => 10, :scale => 5
    add_column :users, :deposit, :decimal, :precision => 10, :scale => 5
    add_column :users, :withdraw, :decimal, :precision => 10, :scale => 5
  end
end
