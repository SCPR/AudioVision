class CreateBillboardPosts < ActiveRecord::Migration
  def change
    create_table :billboard_posts do |t|
      t.integer :post_id
      t.integer :billboard_id
      t.timestamps
    end
  end
end
