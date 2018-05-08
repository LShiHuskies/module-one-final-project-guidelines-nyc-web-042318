def welcome
  puts "Welcome To The BOOKSHELF"
  puts "What is your name?"
  user_name = gets.chomp
  user = User.find_or_create_by(name: user_name)
  user.get_inquiry_type
end
