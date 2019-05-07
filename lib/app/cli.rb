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
      put "we could not find that user name. Please try again."
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
    case input
    when 1
      puts "Let's look at some movies."
       movie_search
    when 2
      puts "Let's look at your movies and reviews."
      # my_movie_list method
    when 3
      # work_in_progress method
    else
      "Please select a valid option"
      main_menu_options
    end
  end

  def movie_search
    

  end

end
