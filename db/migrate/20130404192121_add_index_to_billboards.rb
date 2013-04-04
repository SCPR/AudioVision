class AddIndexToBillboards < ActiveRecord::Migration
  def change
    add_index :billboards, :status
  end
end
