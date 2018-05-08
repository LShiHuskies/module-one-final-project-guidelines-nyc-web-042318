class Book_User < ActiveRecord::Base
  belongs_to :user
  belongs_to :book 
end
