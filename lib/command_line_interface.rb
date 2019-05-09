class CommandLineInterface
  attr_accessor :user, :game

  # * Initial CLI greeting that leads to either getting or creating
  # * a brand new user.
  def greet
    puts 'Welcome to CLI Trivia'
    puts 'Enter your username below to either create or retrieve you account.'
    username = gets.chomp.downcase
    @user = find_or_create(username)
  end

  # * Lists out user options after creating or getting their username.
  # * Calls the required methods to accomplish their choice.
  def options(user)
    display_options
    user_input = gets.chomp.to_i
    case user_input
    when 1
      access_user_info(user)
    when 2
      start_new_game
    when 3
      confirm_delete_account
    when 4
      exit
    else
      puts 'Please provide a valid input'
      options(user)
    end
  end

  def start_new_game
    @game = Game.new
    @usergame = Usergame.new(user_id: user.id, game_id: game.id)
    user.update(id: user.id, num_games: user.num_games += 1)
    play_game
  end

  # * Takes a game instance and a choice from user and updates the
  # * total correct and correct steak for user.
  def evaluate_answer(game, choice)
    if game.correct?(choice)
      update_on_correct_response
      puts "Correct, Your Steak: #{user.correct_streak}"
    else
      user.update(id: user.id, correct_streak: 0)
      puts "Wrong: #{game.correct_answer}"
    end
  end

  private

  # * @return [nil]
  # * Displays the options available to the user.
  def display_options
    puts 'To view account information press the number [1].'
    puts 'To begin a new game press the number [2].'
    puts 'To permanently delete your account [3].'
    puts 'To exit the program [4].'
  end

  # @ Returns instance of User.
  # * finds or creates an instance of user based on provided username.
  def find_or_create(username)
    User.find_or_create_by(username: username)
  end

  # * Puts several pieces of information about the current user.
  def access_user_info(user)
    puts "#{user.username}'s Profile"
    puts "Total Number of Questions Answered Correctly: #{user.total_correct}"
    puts "Current steak: #{user.correct_streak}"
    puts "Number of total games: #{user.num_games}"
    puts "Account made: #{user.created_at}"
    options(user)
  end

  def play_game
    questions_array = game.set_question_data
    until questions_array.empty?
      pre_round_setup
      puts '*****************************************************'
      user_input = game.current_choices[gets.chomp.to_i - 1]
      puts '*****************************************************'
      evaluate_answer(game, user_input)
    end
  end

  def pre_round_setup
    game.set_current_question
    puts game.question_string
    game.set_current_choices
    game.print_choices
  end

  def update_on_correct_response
    t_correct = user.total_correct += 1
    c_streak = user.correct_streak += 1
    user.update(id: user.id, total_correct: t_correct, correct_streak: c_streak)
  end

  # * In between method before deleting your account.
  def confirm_delete_account
    puts 'This action is irreversible.'
    puts 'Type \'delete\' to continue or anything else to exit.'
    user_input = gets.chomp
    user_input == 'delete' ? delete_account : exit
  end

  # * Deletes the users account from the database then reruns the program
  # * from the beginning.
  def delete_account
    User.delete(user.id)
    exit
  end

end

