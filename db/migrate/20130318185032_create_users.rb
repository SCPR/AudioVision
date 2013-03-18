class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.boolean :is_superuser
      t.boolean :can_login, default: true
      t.datetime :last_login
      t.timestamps
    end

    add_index :users, [:email, :can_login]
  end
end
