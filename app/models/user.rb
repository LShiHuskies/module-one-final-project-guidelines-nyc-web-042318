class User < ActiveRecord::Base
    has_many :book_users
    has_many :books, through: :book_users

    def get_author_from_user
      puts "Which author are you interested in?".colorize(:light_blue)
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
      puts "21. Other"
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
      elsif author_choice == "21"
        self.search_api_by_author
      end
    end

    def make_web_request(url)
      all_books=RestClient.get(url)
      JSON.parse(all_books)
    end

    def get_book_hash(author_choice)
      url = "https://www.googleapis.com/books/v1/volumes?q= #{author_choice}&orderBy=relevance&projection=lite&printType=books"
      book_hash = make_web_request(url)
    end

    def find_author_books(author_choice)
      book_array = []
      get_book_hash(author_choice)["items"].each do |quality|
        if quality["volumeInfo"]["authors"] && quality["volumeInfo"]["authors"].include?(author_choice)
        book_array << quality["volumeInfo"]["title"]
        end
      end
      display_booklist(book_array, author_choice)
      save_to_booklist(book_array, author_choice)
    end

    def display_booklist(book_array, author_choice)
      puts "Here is a list of books by #{author_choice}:".colorize(:light_blue)
      puts "-----------------------------------------------------".colorize(:green)
      book_array.each_with_index do |book, i|
        puts "#{i + 1}. #{book}"
      end
      puts "-----------------------------------------------------".colorize(:green)
    end

    def save_to_booklist(book_array, author_choice)
      puts "Would you like to save any of these books to your booklist? If yes, enter the corresponding number. If no, type menu.".colorize(:light_blue)
      selected_input = gets.chomp
      if selected_input == "menu"
        get_inquiry_type(self)
      elsif selected_input.to_i - 1 < book_array.length
        integer_input = selected_input.to_i
        if integer_input <= book_array.length
          new_book = Book.find_or_create_by(title: book_array[integer_input - 1])
          an_author = Author.find_or_create_by(name: author_choice)
          new_book.update(author: an_author)
          if !self.books.include?(new_book)
            self.books << new_book
          end
          # BookUser.find_or_create_by(user_id: self.id, book_id: new_book.id)
          puts "This book has successfully been addded to your booklist.".colorize(:light_blue)
          sleep(1)
          display_booklist(book_array, author_choice)
          save_to_booklist(book_array, author_choice)
        end
      else
        puts "Invalid input.".colorize(:red)
        display_booklist(book_array, author_choice)
        save_to_booklist(book_array, author_choice)
      end
    end


    def titleize(str)
    str.capitalize!
    words_no_cap = ["and", "or", "but", "over", "to", "on", "in", "into"]
    phrase = str.split(" ").map do |word|
      if words_no_cap.include?(word)
        word
      else
        word.capitalize
      end
    end.join(" ")
    phrase
    end

    def search_api_by_title
      puts "What title would you like to search for?".colorize(:light_blue)
      title_input = gets.chomp
      title_input = titleize(title_input)
      book_hash = get_book_hash(title_input)
      book_array = []
      book_author = ""
      if book_hash["items"]
        book_hash["items"].each do |quality|
          if quality["volumeInfo"]["title"] == title_input
            sleep(0.5)
            puts "-----------------------------------------------------".colorize(:green)
            print "Title:".colorize(:light_blue)
            puts " #{quality["volumeInfo"]["title"]}"
            sleep(0.5)
            print "Author:".colorize(:light_blue)
            puts " #{quality["volumeInfo"]["authors"].join}"
            sleep(0.5)
            print "Description:".colorize(:light_blue)
            puts " #{quality["volumeInfo"]["description"]}"
            sleep(0.5)
            print "Publisher:".colorize(:light_blue)
            puts " #{quality["volumeInfo"]["publisher"]}"
            sleep(0.5)
            print "Date of publication:".colorize(:light_blue)
            puts " #{quality["volumeInfo"]["publishedDate"]}"
            puts "-----------------------------------------------------".colorize(:green)
            book_array << quality["volumeInfo"]["title"]
            book_author = quality["volumeInfo"]["authors"].join
            break
          end
        end
      end
      if book_array.length != 0
        save_to_booklist_with_single_book(book_array, book_author)
      else
        puts "No match found.".colorize(:red)
        sleep(1)
        get_inquiry_type(self)
      end
    end

    def save_to_booklist_with_single_book(book_array, book_author)
      puts "Would you like to save this book to your booklist? Enter yes or no.".colorize(:light_blue)
      selected_input = gets.chomp
      if selected_input == "yes"
          new_book = Book.find_or_create_by(title: book_array[0])
          an_author = Author.find_or_create_by(name: book_author)
          new_book.update(author: an_author)
          BookUser.find_or_create_by(user_id: self.id, book_id: new_book.id)
          puts "This book has successfully been addded to your booklist.".colorize(:light_blue)
          sleep(1)
          get_inquiry_type(self)
      elsif selected_input == "no"
        get_inquiry_type(self)
      else
        puts "Invalid input. Please enter yes or no.".colorize(:red)
        save_to_booklist_with_single_book(book_array, book_author)
      end
    end

    def search_api_by_author
      puts "Which author would you like to search for?".colorize(:light_blue)
      author_input = gets.chomp.titleize
      book_hash = get_book_hash(author_input)
      book_array = []
      if book_hash["items"]
        book_hash["items"].each do |quality|
          if quality["volumeInfo"]["authors"] && quality["volumeInfo"]["authors"].include?(author_input)
            book_array << quality["volumeInfo"]["title"]
          end
        end
      end
      if book_array.length != 0
        display_booklist(book_array, author_input)
        save_to_booklist(book_array, author_input)
      else
        puts "No match found.".colorize(:red)
        get_inquiry_type(self)
      end
    end

    def book_user_instances
      BookUser.all.select do |book_user|
        book_user.user == self
      end
    end

    def view_and_rate
      puts "Which of these books would you like to rate? Please enter the corresponding number, or type menu.".colorize(:light_blue)
      sleep(1)
      self.books.each_with_index do |book, i|
        puts "#{i+1}. #{book.title} - #{book.author.name}"
      end
      choice = gets.chomp
      if choice == "menu"
        get_inquiry_type(self)
      elsif choice.to_i - 1 < self.books.length
        choice = choice.to_i
        puts "What is your rating on a scale of 1 to 5?".colorize(:light_blue)
        rating_choice = gets.chomp.to_i
        while rating_choice < 1 || rating_choice > 5
            puts "Invalid rating. Please enter a rating on a scale of 1 to 5.".colorize(:red)
            rating_choice = gets.chomp.to_i
        end
        book_user_instances.each do |instance|
          if instance.book == self.books[choice-1]
            instance.update(review: rating_choice)
            puts "Your review for #{instance.book.title} is #{rating_choice}.".colorize(:light_blue)
            puts "-----------------------------------------------------".colorize(:green)
            sleep(1)
          end
        end
        get_inquiry_type(self)
      else
        puts "Invalid choice.".colorize(:red)
        sleep(1)
        view_and_rate
      end
    end

    def delete_from_booklist
      puts "Which of these books would you like to delete? Please enter the corresponding number.".colorize(:light_blue)
      sleep(0.5)
      self.books.each_with_index do |book, i|
        puts "#{i+1}. #{book.title} - #{book.author.name}"
      end
      choice = gets.chomp.to_i
      while choice - 1 > self.books.length
        puts "That is not a valid choice. Please enter the corresponding number on the above list.".colorize(:red)
        choice = gets.chomp.to_i
      end
      book = self.books[choice - 1]
      puts "#{self.books[choice - 1].title} has been deleted from your booklist.".colorize(:light_blue)
      puts "-----------------------------------------------------".colorize(:green)
      self.books.destroy(book.id)
      sleep(1)
      get_inquiry_type(self)
    end


end
