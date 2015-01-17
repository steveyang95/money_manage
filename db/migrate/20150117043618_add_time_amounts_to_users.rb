class AddTimeAmountsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :previous_month, :integer
    add_column :users, :monthly_deposit, :decimal, :precision => 10, :scale => 5
    add_column :users, :monthly_withdraw, :decimal, :precision => 10, :scale => 5
  end
end
