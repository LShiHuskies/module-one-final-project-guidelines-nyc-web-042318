require 'rest-client'
require 'json'
require 'pry'
# require_relative '../app/models/book.rb'


def make_web_request(url)
  all_books=RestClient.get(url)
  JSON.parse(all_books)
end

def find_author_books(author_choice)
  "#{author_choice}"
  url = "https://www.googleapis.com/books/v1/volumes?q= #{author_choice}&orderBy=relevance&projection=lite&printType=books"

  book_hash = make_web_request(url)
  counter = 0
  book_array = []
  book_hash["items"].each do |quality|
    if quality["volumeInfo"]["authors"] && quality["volumeInfo"]["authors"].include?(author_choice)
    book_array << quality["volumeInfo"]["title"]
    end
  end
  book_array.map do |book|
    counter +=1
    puts "#{counter}. #{book}"
  end
  puts "Would you like to save any of these books to your booklist? If yes, enter the corresponding number."
  selected_input = gets.chomp
  integer_input = selected_input.to_i
  if integer_input <= book_array.length
    new_book = Book.find_or_create_by(title: book_array[integer_input - 1])
    an_author = Author.find_or_create_by(name: author_choice)
    new_book.author = an_author
    # USER_NAME.booklist << new_book
  else
    puts "Invalid input. Please enter a number that corresponds to a book on the above list."
  end
end
