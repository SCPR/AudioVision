class AddTwitterHandleToReporters < ActiveRecord::Migration
  def change
    add_column :reporters, :twitter_handle, :string
  end
end
