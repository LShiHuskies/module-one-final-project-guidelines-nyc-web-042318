class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :title
      t.integer :author_id
      t.integer :publisher_id
    end
  end
end
