class CreateFlatpages < ActiveRecord::Migration
  def change
    create_table :flatpages do |t|
      t.string :path
      t.string :title
      t.string :description
      t.text :content
      t.string :redirect_to
      t.text :extra_head
      t.text :extra_footer
      t.timestamps
    end

    add_index :flatpages, :path
  end
end
