class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title
      t.string :slug
      t.text :description
      t.timestamps
    end

    add_column :posts, :category_id, :integer

    add_index :categories, :slug
    add_index :posts, :category_id
  end
end
