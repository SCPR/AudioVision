class CreatePublishAlarms < ActiveRecord::Migration
  def change
    create_table :publish_alarms do |t|
      t.integer :content_id
      t.string :content_type
      t.datetime :fire_at
      t.timestamps
    end

    add_index :publish_alarms, [:content_id, :content_type]
    add_index :publish_alarms, :fire_at
  end
end
