class CreatePostAssets < ActiveRecord::Migration
  def change
    create_table :post_assets do |t|
      t.integer :asset_id
      t.integer :post_id
      t.integer :position
      t.string :caption
      t.timestamps
    end

    add_index :posts, [:post_id, :position]
  end
end
