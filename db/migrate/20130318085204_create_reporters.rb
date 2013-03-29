class CreateReporters < ActiveRecord::Migration
  def change
    create_table :reporters do |t|
      t.string :name
      t.text :bio
      t.integer :user_id
      t.string :slug
      t.timestamps
    end

    add_index :reporters, :user_id
    add_index :reporters, :slug

    create_table :attributions do |t|
      t.string :name
      t.string :url
      t.boolean :is_included_in_byline, default: true
      t.integer :reporter_id
      t.integer :post_id
      t.timestamps
    end

    add_index :attributions, :reporter_id
    add_index :attributions, [:post_id, :is_included_in_byline]
  end
end
