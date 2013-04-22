class AddCachedBooleanForRelatedArticle < ActiveRecord::Migration
  def change
    add_column :posts, :related_kpcc_article_json_is_cached, :boolean, default: false
  end
end
