class BookUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  # belongs_to :author, through: :book

  def average_rating
    counter = 0
    sum = 0
      self.all.each do |instance|
        sum += instance.review
        binding.pry
        counter += 1
        end
      end
end
