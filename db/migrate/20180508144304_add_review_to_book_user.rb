class AddReviewToBookUser < ActiveRecord::Migration[5.0]
  def change
    add_column :book_users, :review, :integer
  end
end
