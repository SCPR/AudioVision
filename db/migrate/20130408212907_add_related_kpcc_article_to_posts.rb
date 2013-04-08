class AddRelatedKpccArticleToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :related_kpcc_article_url, :string
  end
end
