class AddAssetIdToReporters < ActiveRecord::Migration
  def change
    add_column :reporters, :asset_id, :integer
  end
end
