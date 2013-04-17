class AddEmailToUser < ActiveRecord::Migration
  def change
    add_column :reporters, :email, :string
  end
end
