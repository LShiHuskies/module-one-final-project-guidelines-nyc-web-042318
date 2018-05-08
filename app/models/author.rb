class Author < ActiveRecord::Base
  has_many :books
  # has_many :publishers
end
