class AddIndexToBillboardPosts < ActiveRecord::Migration
  def change
    add_index :billboard_posts, :billboard_id
    add_index :billboard_posts, :post_id
  end
end
