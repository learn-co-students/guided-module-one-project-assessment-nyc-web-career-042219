class CommandLineInterface

  #* Initial CLI greeting that leads to either getting or creating
  #* a brand new user.
  def greet
    puts 'Welcome to CLI Trivia'
    puts 'Enter your username below to either create or retreive you account.'
    username = gets.chomp
    find_or_create(username)
  end

  #* Lists out user options after creating or getting their username.
  #* Calls the required methods to accomplish their choice.
  def options(user)
    puts 'To view account information press the number [1].'
    puts 'To begin a new game press the number [2].'
    user_input = gets.chomp.to_i
    user_input == 1 ? access_user_info(user) : start_new_game
  end

  private

  #@ Returns instance of User.
  #* finds or creates an instance of user based on provided username.
  def find_or_create(username)
    User.find_or_create_by(username: username)
  end

  # TODO: Complete UPDATE operations.
  def access_user_info(user)
    puts "#{user.username}\'s Profile"
    puts "Total Number of Questions Answered Correctly: #{user.total_correct}"
    puts "Current steak: #{user.correct_streak}"
    puts "Number of total games: #{user.num_games}"
    puts "Account made: #{user.created_at}"
  end

end