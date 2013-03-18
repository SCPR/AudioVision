class CreateFlatpages < ActiveRecord::Migration
  def change
    create_table :flatpages do |t|
      t.string :path
      t.string :title
      t.string :description
      t.string :content
      t.string :redirect_to
      t.string :extra_head
      t.string :extra_footer
      t.timestamps
    end

    add_index :flatpages, :path
  end
end
