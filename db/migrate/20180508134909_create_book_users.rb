class CreateBookUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :book_users do |t|
      t.integer :user_id
      t.integer :book_id
    end
  end
end
