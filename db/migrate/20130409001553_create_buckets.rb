class CreateBuckets < ActiveRecord::Migration
  def change
    create_table :buckets do |t|
      t.string :title
      t.text :description
      t.string :key
      t.timestamps
    end

    add_index :buckets, :key
  end
end
