require 'artii'
require 'colorize'

class CLI


  def start
    greeting
    name_confirmation
  end

  def greeting

    a = Artii::Base.new
    a.asciify('FlixNet')
    puts a.asciify('FlixNet').colorize(:blue)

    puts "Welcome to Adam, Jake, and Oscar's movie selector!"
  end


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

  def create_user
    puts "Please enter your name."
    name_input = gets.chomp
    system "clear"
    if !User.find_by(name: name_input)
      @user = User.create(name: name_input)
      main_menu_options
    elsif name_input != String
      puts "Your name must be a string"
      create_user
    else
      puts "This account name is already taken. Please choose another."
      create_user
    end
  end

  def find_user
    puts "Please enter your name."
    name_input = gets.chomp
    system "clear"
    actual_user = User.find_by(name: name_input)
    if !actual_user
      puts "we could not find that user name. Please try again."
      find_user
    else
      @user = actual_user
      main_menu_options
    end
  end

  def main_menu_options
    a = Artii::Base.new
    a.asciify('Menu')
    puts a.asciify('Menu').colorize(:blue)

    puts ""
    puts "1. Search movies."
    puts "2. View your list."
    # puts "3. View your friends or search for friends - work in progress."
    puts ""
    puts "Please input the number corresponding to your choice."
    input = gets.chomp
    system "clear"
    if input == '1'
      puts "Let's look at some movies."
       movie_search
    elsif input == '2'
      format_movie_list
    # elsif input == '3'
      # work_in_progress method
    else
      "Please select a valid option"
      main_menu_options
    end
  end

  def movie_search

    puts "Please enter the name of the movie you would like to search"
    input = gets.chomp
    system "clear"
    query_response = RestClient.get("http://www.omdbapi.com/?s=#{input}&apikey=a2d3299b")

    parsed_response = JSON.parse(query_response)

    movie_results = parsed_response["Search"].map do |movie|
      movie["Title"]
    end
    puts "Your search returned the following results:"

    movie_results.each.with_index(1).map do |movie, index|
      puts "#{index}. #{movie}"
    end
    find_movie_from_list(movie_results)
  end



  def find_movie_from_list(movie_results)
    puts "Please select the number of the movie you'd like to add to your list"
    input = gets.chomp

    new_input = input.to_i - 1
      movie_title = ""
      movie_results.each do |movie|
        if movie_results.index(movie) == new_input
          movie_title = movie
        end
      end
    find_movie_by_title(movie_title)
  end

  def find_movie_by_title(arg)
    query_response = RestClient.get("http://www.omdbapi.com/?t=#{arg}&apikey=a2d3299b")
    parsed_response = JSON.parse(query_response)
    movie_deets_hash =
    {"Title" => parsed_response["Title"],
    "Released" => parsed_response["Released"].slice(-4..).to_i,
    "Genre" => parsed_response["Genre"],
    "Director" => parsed_response["Director"]}
    add_movie_to_database(movie_deets_hash)
  end

  def add_movie_to_database(hash)
  movie_object =  Movie.find_or_create_by(title: hash["Title"],
                  release_year: hash["Released"],
                  genre: hash["Genre"],
                  director: hash["Director"])
      add_movie_to_mylist(movie_object)
  end

  def add_movie_to_mylist(movie_object)
    puts "Do you want to add this movie to your list?(y/n)"
    input = gets.chomp
    system "clear"
    if input == "y"
      List.find_or_create_by(user_id: @user.id, movie_id: movie_object.id, title: movie_object.title )
      format_movie_list
    elsif input == "n"
      movie_search
    else
      puts "Please enter a valid response."
        add_movie_to_mylist(movie_object)
    end
  end

  def get_movie_list
    movie_list = List.all.select do |movie|
      movie.user_id == @user.id
    end
    movie_list
  end

  def format_movie_list #this method formats the users list of movies with a number next to the movie title

    movie_names = get_movie_list.map do |movielist|
      Movie.all.find(movielist.movie_id).title
    end

    if movie_names.length ==0
      puts "You currently have no movies in your list, try searching for a movie!"
      puts ""
      main_menu_options
    else
    puts "Here's your list of movies:"
     formatted_movie_names = movie_names.each.with_index(1).map do |movie, index|
      puts "#{index}. #{movie}"
     end
     movie_list_options_list
     #select_movie_from_list_menu
   end
  end

  def movie_list_options_list
    puts ""
    puts "What would you like to do \n 1) Select a movie from the list \n 2) See your favorite Genre \n 3) See your favorite Director"
    input = gets.chomp
    updated_rating = input.to_i
    system("clear")

    if updated_rating.between?(1,3) == false
      puts "Please input a number between 1 and 3"
      movie_list_options_list
    else
      case updated_rating
      when 1
        select_movie_from_list_menu
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
        movie_list_options_list
      end
    end
  end


  def select_movie_from_list_menu #this method allows a user to select a movie from the number next to its title
    movie_list = get_movie_list
    puts "Please select a movie by number."

    selected_movie = movie_list.first
    input = gets.chomp
    system "clear"
    new_input = input.to_i - 1
    movie_list.each do |movielist|
      if movie_list.index(movielist) == new_input
        selected_movie = movielist
      end
    end
    selected_movie

    act_on_selected_movie(selected_movie)
  end

  def act_on_selected_movie(selected_movie) #this method it the movie list MENU that allows the user to select the action the way to take
    puts "You have selected: #{selected_movie.title}"
    #puts "Please select the action you'd like to take: 1) Write a Review"
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

  def write_a_review(movie)
    puts "Please select the rating you'd like to give this movie, from 1 - 10"
    input = gets.chomp
    updated_rating = input.to_i

    if updated_rating.between?(1,10) == false
      puts "Please give your movie a rating from 1 - 10"
      write_a_review(movie)
    else
      updated_rating = input.to_i
      movie.rating = updated_rating

      puts "Please write a review for this movie"
      input = gets.chomp

      movie.review = input
      movie.save
      system "clear"
      main_menu_options
    end
  end

  def view_review(arg)
    if arg.rating == nil
      puts "You have not rated/review this movie."
      write_a_review(arg)
    else
      puts "You gave this movie the following rating: #{arg.rating}"
      puts "You gave this movie the following review:"
      puts "#{arg.review}"
      puts "Would you like to update your rating/review? y/n"
    end
    new_input = gets.chomp
    system "clear"
    case new_input
    when "y"
      write_a_review(arg)
    when "n"
      main_menu_options()
    else
      view_review(arg)
      #this will send them back to the beginning
      end
    end

    def delete_movie_from_list(arg)
      puts "You've removed #{arg.title} from your list."
      arg.destroy
      main_menu_options
    end

  end
