class AddPhoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone_number, :string, :null => false
  end
end
