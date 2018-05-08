class Book < ActiveRecord::Base
  belongs_to :author
  # belongs_to :publisher
  has_many :book_users
  has_many :users, through: :book_users
end
