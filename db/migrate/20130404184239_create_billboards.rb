class CreateBillboards < ActiveRecord::Migration
  def change
    create_table :billboards do |t|
      t.integer :layout
      t.integer :status
      t.datetime :published_at
      t.timestamps
    end
  end
end
