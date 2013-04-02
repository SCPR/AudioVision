class CreatePostAssets < ActiveRecord::Migration
  def change
    create_table :post_assets do |t|
      t.integer :asset_id
      t.integer :post_id
      t.integer :position
      t.text :caption
      t.timestamps
    end

    add_index :post_assets, [:post_id, :position]
  end
end
