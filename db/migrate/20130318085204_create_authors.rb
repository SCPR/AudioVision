class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.text :bio
      t.integer :user_id
      t.string :name
      t.string :slug
    end

    add_index :authors, :user_id
    add_index :authors, :slug
  end
end
