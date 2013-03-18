class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :slug
      t.integer :status
      t.text :body
      t.datetime :published_at
      t.text :teaser
      t.string :media_type
      t.timestamps
    end

    add_index :posts, :media_type
    add_index :posts, [:status, :published_at]
  end
end
