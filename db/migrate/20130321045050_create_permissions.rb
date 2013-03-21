class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :resource
      t.timestamps
    end

    add_index :permissions, :resource
  end
end
