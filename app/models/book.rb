class Book < ActiveRecord::Base
  belongs_to :author
  has_many :book_users
  has_many :users, through: :book_users

  def self.get_title_for_average_rating(user)
    puts "For which book would you like to see the average rating?".colorize(:light_blue)
    Book.all.each_with_index do |book, i|
      puts "#{i + 1}. #{book.title} - #{book.author.name}"
    end
    user_choice = gets.chomp.to_i
    new_title = Book.all[user_choice - 1].title
    average_rating(new_title, user)
  end

  def self.average_rating(new_title, user)
    a_book = Book.find_by(title: new_title)
    average = a_book.book_users.sum(:review) / a_book.book_users.length.to_f
    puts "The average review is #{average}.".colorize(:light_blue)
    get_inquiry_type(user)
  end

  def self.average_rating(new_title, user)
    a_book = Book.find_by(title: new_title)
    books_with_no_nil = []
    books_with_no_nil << a_book.book_users.where.not(review: nil)
    average = a_book.book_users.sum(:review) / books_with_no_nil.length
    puts "The average review is #{average}.".colorize(:light_blue)
    get_inquiry_type(user)
  end
end
