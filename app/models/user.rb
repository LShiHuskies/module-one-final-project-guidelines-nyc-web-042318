class User < ActiveRecord::Base
    has_many :book_users
    has_many :books, through: :book_users

    def get_inquiry_type
      puts "What would you like to do? (select number)"
      puts "1. Get a list of books by an author."
      puts "2. Find all the books published by a publisher within past year."
      puts "3. Find a book based on ISBN." #(LIMIT BY 1)
      puts "4. Get the most recent book by an author." #(limit by 1)
      ## Find a book based on title and get the description
      ## Get a list of books from a particular publisher
      ## Rate the books in your booklist
      user_input = gets.chomp

      if user_input == "1"
        self.get_author_from_user
      end

    end

    def get_author_from_user
      puts "Which author are you interested in?"
      puts "1. John Ashbery"
      puts "2. Daniel Borzutzky"
      puts "3. Lucie Brock-Broido"
      puts "4. Anne Carson"
      puts "5. Alex Dimitrov"
      puts "6. Rita Dove"
      puts "7. Carolyn Forché"
      puts "8. Louise Glück"
      puts "9. Terrance Hayes"
      puts "10. Yusef Komunyakaa"
      puts "11. Dorothea Lasky"
      puts "12. Ben Lerner"
      puts "13. Fred Moten"
      puts "14. Eileen Myles"
      puts "15. Maggie Nelson"
      puts "16. Alice Notley"
      puts "17. Claudia Rankine"
      puts "18. Adrienne Rich"
      puts "19. Tracy K. Smith"
      puts "20. Raúl Zurita"
      author_choice = gets.chomp
      if author_choice == "1"
        self.find_author_books("John Ashbery")
      elsif author_choice == "2"
        self.find_author_books("Daniel Borzutzky")
      elsif author_choice == "3"
        self.find_author_books("Lucie Brock-Broido")
      elsif author_choice == "4"
        self.find_author_books("Anne Carson")
      elsif author_choice == "5"
        self.find_author_books("Alex Dimitrov")
      elsif author_choice == "6"
        self.find_author_books("Rita Dove")
      elsif author_choice == "7"
        self.find_author_books("Carolyn Forché")
      elsif author_choice == "8"
        self.find_author_books("Louise Glück")
      elsif author_choice == "9"
        self.find_author_books("Terrance Hayes")
      elsif author_choice == "10"
        self.find_author_books("Yusef Komunyakaa")
      elsif author_choice == "11"
        self.find_author_books("Dorothea Lasky")
      elsif author_choice == "12"
        self.find_author_books("Ben Lerner")
      elsif author_choice == "13"
        self.find_author_books("Fred Moten")
      elsif author_choice == "14"
        self.find_author_books("Eileen Myles")
      elsif author_choice == "15"
        self.find_author_books("Maggie Nelson")
      elsif author_choice == "16"
        self.find_author_books("Alice Notley")
      elsif author_choice == "17"
        self.find_author_books("Claudia Rankine")
      elsif author_choice == "18"
        self.find_author_books("Adrienne Rich")
      elsif author_choice == "19"
        self.find_author_books("Tracy K. Smith")
      elsif author_choice == "20"
        self.find_author_books("Raúl Zurita")
      end
    end

    def make_web_request(url)
      all_books=RestClient.get(url)
      JSON.parse(all_books)
    end

    def get_book_hash(author_choice)
      url = "https://www.googleapis.com/books/v1/volumes?q= #{author_choice}&orderBy=relevance&projection=lite&printType=books"

      book_hash = make_web_request(url)
      book_hash
    end

    def find_author_books(author_choice)
      book_hash = get_book_hash(author_choice)
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
      save_to_booklist(book_array, author_choice)
    end

    def save_to_booklist(book_array, author_choice)
      puts "Would you like to save any of these books to your booklist? If yes, enter the corresponding number."
      ##We need to add some functionality so that the user can enter no and leave the app.
      selected_input = gets.chomp
      integer_input = selected_input.to_i
      if integer_input <= book_array.length
        new_book = Book.find_or_create_by(title: book_array[integer_input - 1])
        an_author = Author.find_or_create_by(name: author_choice)
        new_book.author = an_author
        Book_User.find_or_create_by(user_id: self.id, book_id: new_book.id)
      else
        puts "Invalid input. Please enter a number that corresponds to a book on the above list."
      end
    end

    def book_user_instances
      Book_User.all.select do |book_user|
        book_user.user == self
      end
    end

    def booklist
      self.book_user_instances.map do |book_user_instance|
        book_user_instance.book
      end
    end

end
