class AddDefaultToIsListed < ActiveRecord::Migration
  def change
    change_column :reporters, :is_listed, :boolean, default: false
  end
end
