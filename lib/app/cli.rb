class CLI


  def start
    greeting
    name_confirmation
  end

  def greeting
    puts "Welcome to Adam, Jake, and Oscar's movie selector!"
  end


  def name_confirmation
    puts "Been here before? (y/n)"
    user_response = gets.chomp
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
    if !User.find_by(name: name_input)
      @user = User.create(name: name_input)
      main_menu_options
    else
      puts "This account name is already taken. Please choose another."
      create_user
    end
  end

  def find_user
    puts "Please enter your name."
    name_input = gets.chomp
    actual_user = User.find_by(name: name_input)
    if !actual_user
      puts "we could not find that user name. Please try again."
      find_user
    else
      puts "Welcome back, #{actual_user.name}! Let's go the main menu"
      @user = actual_user
      main_menu_options
    end
  end

  def main_menu_options
    puts "1. Search movies."
    puts "2. View your list."
    puts "3. View your friends or search for friends - work in progress."
    puts "Please input the number corresponding to your choice."
    input = gets.chomp
    if input == '1'
      puts "Let's look at some movies."
       movie_search
    elsif input == '2'
      puts "Let's look at your movies and reviews."
      # my_movie_list method
    elsif input == '3'
      # work_in_progress method
    else
      "Please select a valid option"

    end
  end

  def movie_search
    puts "Please enter the name of the movie you would like to search"
    input = gets.chomp

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
    #binding.pry
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
    Movie.find_or_create_by(title: hash["Title"],
      release_year: hash["Released"],
      genre: hash["Genre"],
      director: hash["Director"])
  end

end
