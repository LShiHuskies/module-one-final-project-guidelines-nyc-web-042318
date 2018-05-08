def welcome
  puts "Welcome To The BOOKSHELF"
  puts "What is your name?"
  user_name = gets.chomp
  user = User.find_or_create_by(name: user_name)
  get_inquiry_type(user)
end

def get_inquiry_type(user)
  puts "What would you like to do? (select number)"
  puts "1. Get a list of books by an author."
  puts "2. Search for book by title."
  puts "3. View booklist and rate books."
  puts "4. Get average rating for a book."
  puts "5. Exit"

  user_input = gets.chomp

  if user_input == "1"
    user.get_author_from_user
  elsif user_input == "2"
    user.search_api_by_title
  elsif user_input == "3"
    user.view_and_rate
  elsif user_input == "4"
    user.get_title_for_average_rating
  elsif user_input == "5"
    puts "Thanks for visiting the BOOKSHELF!"
    exit
  else
    puts "Invalid choice. Please enter a valid selection."
    get_inquiry_type(user)
  end
end
