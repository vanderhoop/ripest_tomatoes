class AddZipToUsers < ActiveRecord::Migration
  def change
    add_column :users, :zip_code, :string, :null => false, :default => ""
  end
end
