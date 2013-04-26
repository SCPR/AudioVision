class RemoveCacheBoolean < ActiveRecord::Migration
  def change
    remove_column :posts, :related_kpcc_article_json_is_cached
  end
end
