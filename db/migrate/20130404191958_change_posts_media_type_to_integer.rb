class ChangePostsMediaTypeToInteger < ActiveRecord::Migration
  def change
    change_column :posts, :media_type, :integer
  end
end
