require 'artii'
require 'colorize'

class CLI

  def start
    greeting
    name_confirmation
  end

  #print ASCII Heading and greet user
  def greeting
    a = Artii::Base.new
    a.asciify('FlixNet')
    puts a.asciify('FlixNet').colorize(:blue)

    puts "Welcome to Adam, Jake, and Oscar's movie Database!"
  end

  #Let user sign in/up
  def name_confirmation
    puts "Been here before? (y/n)"
    user_response = gets.chomp.downcase
    system "clear" 
    if user_response == "y"
      find_user
    elsif user_response == "n"
      create_user
    else
      name_confirmation
    end
  end

  #create user account
  def create_user
    puts "Please enter your name."
    name_input = gets.chomp
    system "clear"
    if !User.find_by(name: name_input) #check to see if the users inputted name is NOT taken
      @user = User.create(name: name_input)
      main_menu_options
    elsif name_input != String #prevent the user from inputting anything other than a string. #todo Check if this is necessary"
      puts "Your name must be a string"
      create_user
    else
      puts "This account name is already taken. Please choose another."
      create_user
    end
  end

  #allow user to sign in
  def find_user
    puts "Please enter your name."
    name_input = gets.chomp
    system "clear"
    actual_user = User.find_by(name: name_input) #look up user name
    if !actual_user #check if name matches user input
      puts "we could not find that user name. Please try again."
      find_user
    else
      @user = actual_user #set the user name to a class variable for later user
      main_menu_options #send user to main menue
    end
  end

  #display main menu to user and allow them to make a suggestion
  def main_menu_options
    a = Artii::Base.new #display main title greeting
    a.asciify('Menu')
    puts a.asciify('Menu').colorize(:blue)

    puts ""
    puts "1. Search movies."
    puts "2. View your list."
    puts ""
    puts "Please input the number corresponding to your choice."
    input = gets.chomp #todo Check to see if you can break this
    system "clear"
    if input == '1'
      puts "Let's look at some movies."
       movie_search #send user to the movie search screen
    elsif input == '2'
      display_movie_list_and_movie_list_options #send movie to the movie list screen
    else
      "Please select a valid option"
      main_menu_options #call the method again
    end
  end

  #allow user to query the API
  def movie_search

    puts "Please enter the name of the movie you would like to search"
    input = gets.chomp
    system "clear"
    query_response = RestClient.get("http://www.omdbapi.com/?s=#{input}&apikey=a2d3299b") #send query to database to search for movies containing the the user's input in the title

    parsed_response = JSON.parse(query_response) #parse the response into a hash

    movie_results = parsed_response["Search"].map do |movie| #iterate through the hash and extract the movie titles into an array
      movie["Title"] 
    end
    puts "Your search returned the following results:"

    #todo !iterate through the hash again (movie_reslts) to get the release year of each movie
    movie_years = parsed_response["Search"].map do |movie| #iterate through the hash and extract the movie year into an array
      movie["Year"]
    end


    movie_results.each.with_index(1).map do |movie, index| #iterate through the array of movie titles and print them to the screen, along with their index # + 1
      puts "#{index}. #{movie}"
    end
    find_movie_from_list(movie_results) #allow the user to select a movie from their movie list
  end

  #allow the user to select a movie from their movie list
  def find_movie_from_list(movie_results)
    puts "Please select the number of the movie you'd like to add to your list"
    input = gets.chomp

    new_input = input.to_i - 1 #convert the input to an integer and -1 from it
      movie_title = ""
      movie_results.each do |movie| #iterate through the list of movies and select the one with the matching index
        if movie_results.index(movie) == new_input
          movie_title = movie
        end
      end
    find_movie_by_title(movie_title) #query the database and retrieve the expanded entry for the movie
  end
  
  #query the database and retrieve the expanded entry for the movie
  def find_movie_by_title(arg)
    query_response = RestClient.get("http://www.omdbapi.com/?t=#{arg}&apikey=a2d3299b") #query the database
    parsed_response = JSON.parse(query_response) #parse the response into a useable hash
    movie_deets_hash = #extract relevant details from the hash
    {"Title" => parsed_response["Title"],
    "Released" => parsed_response["Released"].slice(-4..).to_i,
    "Genre" => parsed_response["Genre"],
    "Director" => parsed_response["Director"]}
    add_movie_to_database(movie_deets_hash) #create a movie_object for the selected movie, if it doesn't already exist
  end

  #create a movie_object for the selected movie, if it doesn't already exist
  def add_movie_to_database(hash)
  movie_object =  Movie.find_or_create_by(title: hash["Title"], #check for a movie given the extracted details, create if not found
                  release_year: hash["Released"],
                  genre: hash["Genre"],
                  director: hash["Director"])
      add_movie_to_mylist(movie_object) #Allow the user to add the movie object to (through) their list
  end

  def add_movie_to_mylist(movie_object)
    puts "Do you want to add this movie to your list?(y/n)"
    input = gets.chomp #todo test this input more thoroughly
    system "clear"
    if input == "y"
      List.find_or_create_by(user_id: @user.id, movie_id: movie_object.id, title: movie_object.title ) #todo create the movie_list object
      display_movie_list_and_movie_list_options #call the method that displays the movie_list_menu #todo rename this method and refactor so it serves a single purpose
    elsif input == "n"
      main_menu_options #! NOTE TO ADAM/OSCAR! Changed this from going immediately back to the movie search via #movie_search
    else
      puts "Please enter a valid response."
        add_movie_to_mylist(movie_object) #calls method again if the user does not enter either 'y' or ' n'
    end
  end

  #get each movie_list object that belongs to the @user
  def get_movie_list
    movie_list = List.all.select do |movie| #select the movie_list objects with a foreign ID column for user that matches the user's ID
      movie.user_id == @user.id
    end
    movie_list #return the array of selected movie_list objects
  end

  #change this method into two parts: formatting the movie list and displaying it
  def format_movie_list #this method formats the users list of movie_list objects with a number next to the movie title
    movie_names = get_movie_list.map do |movielist| #iterate through array of selected movie_list objects and fetch their title
      Movie.all.find(movielist.movie_id).title
    end
    formatted_movie_names = movie_names.each.with_index(1).map do |movie, index| #iterage through the list of movie_object titles and prepend them with their index +1
      "#{index}. #{movie}"
    end

    if movie_names.length == 0 #check that the user has movies in their movie list, send to main menu if they don't
      puts "You currently have no movies in your list, try searching for a movie!"
      puts ""
      main_menu_options
    else
    formatted_movie_names #make the list of prepended movie_list object titles the return value
    end
  end

  #display the prepended list of movie_list object titles ONLY
  def display_movie_list_only
    puts "Here's your list of movies:"
    puts format_movie_list
  end

  #display the preppended list of movie_list object titles AND allow user to select an action regarding thos titles
  def display_movie_list_and_movie_list_options
    puts format_movie_list
    movie_list_options_list
  end

  #allow user to select an action upon seeing their list of pre-pended movie_list objects
  def movie_list_options_list
    puts ""
    puts "What would you like to do \n 1) Select a movie from the list \n 2) See your favorite Genre \n 3) See your favorite Director"
    input = gets.chomp
    updated_rating = input.to_i
    system("clear")

    if updated_rating.between?(1,3) == false #check to make sure user input is either 1, 2, or 3
      puts "Please input a number between 1 and 3"
      # puts "What would you like to do \n 1) Select a movie from the list \n 2) See your favorite Genre \n 3) See your favorite Director" #!Is this necessary if we're calling the method again? Could result in printing these directives out twice in event of inaccurate user input
      movie_list_options_list
    else
      case updated_rating
      when 1
        select_movie_from_list_menu #method below
      when 2
        puts "Your favorite genre is: #{@user.find_most_popular_genre}"
        puts ""
        puts ""
        main_menu_options
      when 3
        puts "Your favorite director is: #{@user.find_most_popular_director}"
        puts ""
        puts ""
        main_menu_options
      else
        movie_list_options_list #!Test this more thoroughly
      end
    end
  end

  #allow a user to select a movie from the number next to its title
  def select_movie_from_list_menu
    puts display_movie_list_only
    puts "Please select a movie by number."

    movie_list = get_movie_list #get list of movie_list objects associated with @user
    selected_movie = movie_list.first #set variable selected_movie to a movie list object with the intention of reassigning its value later
    input = gets.chomp.to_i
    new_input = input.to_i - 1
    system "clear"
#binding.pry
    if input.between?(1, get_movie_list.size) == false #check to make sure user input is either 1, 2, or 3
        puts "Please input a valid number that corresponds to a number on the above list"
        select_movie_from_list_menu
      
    else
      movie_list.each do |movielist| #iterate over list of users movie_list objects to find one with an index number equal to the users input -1
      if movie_list.index(movielist) == new_input
          selected_movie = movielist
      end 
    end
    end
   # selected_movie #commented out, did not seem to server a purpose
    act_on_selected_movie(selected_movie)
  end

  #list the actions the user can undertake on their selected movie_list object
  def act_on_selected_movie(selected_movie)
    puts "You have selected: #{selected_movie.title}"
    puts "If you would like to rate and review - press 1"
    puts "To view your review - press 2"
    puts "To delete this movie from your list - press 3"
    puts "To go back to main menu - press 4"
    input = gets.chomp
    system "clear"
      if input == "1"
        write_a_review(selected_movie)
      elsif input == "2"
        view_review(selected_movie)
      elsif input == "4"
        main_menu_options
      elsif input == "3"
        delete_movie_from_list(selected_movie)
      else
        puts "Please enter a valid option"
        act_on_selected_movie(selected_movie)
      end
  end

  #allow the user to associate a review with one of their movie_list_objects
  def write_a_review(movie)
    puts "Please select the rating you'd like to give this movie, from 1 - 10"
    input = gets.chomp
    updated_rating = input.to_i

    if updated_rating.between?(1,10) == false #check if user input is an integer between 1 - 10
      puts "Please give your movie a rating from 1 - 10"
      write_a_review(movie)
    else
      # updated_rating = input.to_i #this line seems superfluous
      movie.rating = updated_rating

      puts "Please write a review for this movie"
      input = gets.chomp

      movie.review = input
      movie.save
      system "clear"
      main_menu_options
    end
  end

  #allow user to view their review with their selected movie_list object
  def view_review(arg)
    if arg.rating == nil #check if the user has created a rating/review for the movie_list object
      puts "You have not rated/review this movie."
      write_a_review(arg)
    else
      puts "You gave this movie the following rating: #{arg.rating}"
      puts ""
      puts "You gave this movie the following review:"
      puts ""
      puts "#{arg.review}"
      puts ""
      puts "Would you like to update your rating/review? y/n"
    end
    new_input = gets.chomp
    system "clear"
    case new_input #!Test this input more thoroughly
    when "y"
      write_a_review(arg)
    when "n"
      main_menu_options()
    else
      view_review(arg)
      #send user back to the beginning
      end
    end

    #allow user to remove a movie_list object from their movielist by destroying the instance
    def delete_movie_from_list(arg)
      puts "You've removed #{arg.title} from your list."
      arg.destroy
      main_menu_options
    end
  
end