class CreateInteractions < ActiveRecord::Migration
  def change
    create_table :interactions do |t|
      t.references :user, index: true
      t.references :movie, index: true
      t.string :type

      t.timestamps
    end
  end
end
