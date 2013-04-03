class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :email
      t.string :password_digest
      t.boolean :can_login
      t.boolean :is_superuser
      t.datetime :last_login
      t.timestamps
    end
  end
end
