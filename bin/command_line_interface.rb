def welcome
  puts "Welcome To The BOOKSHELF"
  puts "What is your name?"
  user_name = gets.chomp
  get_inquiry_type
end

def get_inquiry_type
  puts "What would you like to do? (select number)"
  puts "1. Get a list of books by an author."
  puts "2. Find all the books published by a publisher within past year."
  puts "3. Find a book based on ISBN." #(LIMIT BY 1)
  puts "4. Get the most recent book by an author." #(limit by 1)
  user_input = gets.chomp

  if user_input == "1"
    get_author_from_user
  end

end

def get_author_from_user
  puts "Which author are you interested in?"
  author_choice = gets.chomp
  find_author_books(author_choice)
end

# def find_author_books(author_choice)
#
# end

# def get_publisher_from_user
#     puts "Which publisher's catalog would you like to search?"
#     puts "1. Random House"
#     puts "2. Penguin"
#     puts "3. Simon and Schuster"
#     puts "4. MacMillan"
#     puts "5. Wave Books"
#     puts "6. GreyWolf"
#     puts "7. Exit"
#     user_input = gets.chomp
#
#     if ["1", "2", "3", "4", "5", "6"].include?(user_input)
#       search_catalog_for_author(user_input)
#     else
#       exit
#     end
# end
