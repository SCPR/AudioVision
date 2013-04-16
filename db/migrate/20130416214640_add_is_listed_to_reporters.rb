class AddIsListedToReporters < ActiveRecord::Migration
  def change
    add_column :reporters, :is_listed, :boolean
    add_index :reporters, :is_listed
  end
end
