class DropBillboardPosts < ActiveRecord::Migration
  def change
    drop_table :billboard_posts
  end
end
