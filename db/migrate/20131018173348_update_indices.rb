class UpdateIndices < ActiveRecord::Migration
  def change
    add_index :attributions, :post_id

    remove_index :billboards, :status
    add_index :billboards, [:published_at, :status]

    add_index :posts, :published_at
    add_index :posts, :status
    add_index :posts, :updated_at

    add_index :users, :name
  end
end
