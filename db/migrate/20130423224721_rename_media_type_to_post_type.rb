class RenameMediaTypeToPostType < ActiveRecord::Migration
  def change
    rename_column :posts, :media_type, :post_type
  end
end
