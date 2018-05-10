class Book < ActiveRecord::Base
  belongs_to :author
  has_many :book_users
  has_many :users, through: :book_users

  def self.get_title_for_average_rating(user)
    puts "For which book would you like to see the average rating?".colorize(:light_blue)
    sleep(0.5)
    Book.all.each_with_index do |book, i|
      puts "#{i + 1}. #{book.title} - #{book.author.name}"
    end
    user_choice = gets.chomp.to_i
    while user_choice.to_i > Book.all.length
      puts "Invalid input. Please enter a number that corresponds to the above list.".colorize(:red)
      user_choice = gets.chomp.to_i
    end
      new_title = Book.all[user_choice - 1].title
      average_rating(new_title, user)
  end

  def self.average_rating(new_title, user)
    a_book = Book.find_by(title: new_title)
    books_with_no_nil = a_book.book_users.where.not(review: nil)
    average = a_book.book_users.sum(:review) / books_with_no_nil.length.to_f
    #binding.pry
    if average > 0
      puts "The average review is #{average.round(2)}.".colorize(:light_blue)
      puts "-----------------------------------------------------".colorize(:green)
    else
      puts "There are no reviews for #{new_title}.".colorize(:light_blue)
    end
    sleep(1)
    get_inquiry_type(user)
  end
end
