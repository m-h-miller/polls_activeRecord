class CreateResponse < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :answer_choice_id
      t.integer :user_id

      t.timestamps
    end

    add_index :responses, :answer_choice_id
  end
end
