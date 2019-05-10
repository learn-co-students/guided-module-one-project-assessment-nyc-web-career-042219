class CommandLineInterface < Design
  attr_accessor :user, :game

  # * Initial CLI greeting that leads to either getting or creating
  # * a brand new user.
  def greet
    title_call
    print_asterisks
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
      high_scores
    when 4
      confirm_delete_account
    when 5
      exit
    else
      puts 'Please provide a valid input'
      puts
      options(user)
    end
  end

  def start_new_game
    loading_bar
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
    puts
  end

  private

  # * @return [nil]
  # * Displays the options available to the user.
  def display_options
    puts
    puts 'To view account information press the number [1]'
    puts 'To begin a new game press the number [2]'
    puts 'To view HIGH SCORES press the number [3]'
    puts 'To permanently delete your account press the number [4]'
    puts 'To exit the program press the number [5].'
    puts
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
    puts "Current streak: #{user.correct_streak}"
    puts "Longest Streak #{user.longest_streak}"
    puts "Number of total games: #{user.num_games}"
    puts "Account made: #{user.created_at}"
    options(user)
  end

  def play_game
    attributes = setup_game
    game.update(num_games: game.num_games + 1)
    questions_array = game.set_question_data(attributes)
    until questions_array.empty?
      pre_round_setup
      print_asterisks
      user_input = game.current_choices[gets.chomp.to_i - 1]
      print_asterisks
      evaluate_answer(game, user_input)
    end
    print_asterisks
    puts 'Thanks for playing, see you soon'
    options(user)
  end

  # Calls various methods before the the user input.
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
    longest_streak
  end

  # helper method for update_on_correct_response
  def longest_streak
    total_l_streak = user.longest_streak
    l_streak = user.correct_streak
    user.update(id: user.id, longest_streak: l_streak) if l_streak > total_l_streak
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

  def setup_game
    print_asterisks
    num_questions = display_game_length_options
  end

  def display_game_length_options
    puts 'How many questions would you like to have?'
    user_input = gets.chomp.to_i
    # unless user_input.class == Integer
    #   puts
    #   puts "#{user_input} is not a valid number."
    #   display_game_length_options
    # end
    user_input
  end

  def high_scores
    if user.username.casecmp(User.order(longest_streak: :DESC).first.username).zero?
      highest_score
    else
      User.order(longest_streak: :DESC).select do |user|
        puts "#{user.username} - Score #{user.longest_streak}"
      end
      sleep(2.5)
      options(user)
    end
  end

  def highest_score
    high_score_reward
    high_score_you
    print_asterisks
    puts "                  #{user.username.upcase} -- #{user.longest_streak}"
    print_asterisks
    sleep(2.5)
    User.order(longest_streak: :DESC).select do |user|
      puts "#{user.username.upcase} - Score #{user.longest_streak}"
    end
    print_asterisks
    options(user)
  end

end


