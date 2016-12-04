class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :password_digest, null: false
      t.string :name
      t.integer :role, null: false, default: 2

      t.timestamps null: false
    end
  end
end
