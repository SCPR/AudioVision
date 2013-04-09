class CreatePostReferences < ActiveRecord::Migration
  def change
    create_table :post_references do |t|
      t.string :referrer_type
      t.integer :referrer_id
      t.integer :post_id
      t.integer :position
      t.timestamps
    end

    add_index :post_references, :post_id
    add_index :post_references, :position
    add_index :post_references, [:referrer_type, :referrer_id]
  end
end
