class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name

      t.timestamps
    end

    add_index :users, [:user_name], name: "index_user_name", unique: true
  end
end
