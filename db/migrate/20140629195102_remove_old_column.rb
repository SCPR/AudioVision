class RemoveOldColumn < ActiveRecord::Migration
  def up
    remove_column :posts, :related_kpcc_article_json_is_cached
  end

  def down
    # nope
  end
end
