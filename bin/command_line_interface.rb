def welcome
  puts "Welcome To The BOOKSHELF".colorize(:light_blue)
  puts "What is your name?".colorize(:green)
  user_name = gets.chomp
  user = User.find_or_create_by(name: user_name)
  get_inquiry_type(user)
end

def get_inquiry_type(user)
  puts "What would you like to do? (select number)".colorize(:light_blue)
  puts "1. Search for books by author."
  puts "2. Search for book by title."
  puts "3. View booklist and rate books."
  puts "4. Get average rating for a book."
  puts "5. Delete book from booklist."
  puts "6. Exit"

  user_input = gets.chomp

  if user_input == "1"
    user.get_author_from_user
  elsif user_input == "2"
    user.search_api_by_title
  elsif user_input == "3"
    user.view_and_rate
  elsif user_input == "4"
    Book.get_title_for_average_rating(user)
  elsif user_input == "5"
    user.delete_from_booklist
  elsif user_input == "6"
    puts "Thanks for visiting the BOOKSHELF!".colorize(:green)
    exit
  else
    puts "Invalid choice. Please enter a valid selection.".colorize(:red)
    get_inquiry_type(user)
  end
end
