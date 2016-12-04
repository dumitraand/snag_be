class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :password, null: false
      t.string :api_key, null: false

      t.timestamps null: false
    end
  end
end
