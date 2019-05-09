class CommandLineInterface
  attr_accessor :user, :game

  # * Initial CLI greeting that leads to either getting or creating
  # * a brand new user.
  def greet
    title_call
    puts "*" * 100
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
      options(user)
    end
  end

  def loading_bar
    puts "LOADING dat TRIVIA YO"
    spinner = Enumerator.new do |e|
      loop do
    e.yield '|'
    e.yield '/'
    e.yield '-'
    e.yield '\\'
    end
  end

  1.upto(100) do |i|
  progress = "=" * (i/5) unless i < 5
  printf("\rCombined: [%-20s] %d%% %s", progress, i, spinner.next)
  sleep(0.1)
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
      puts "Correct, Your Streak: #{user.correct_streak}"
    else
      user.update(id: user.id, correct_streak: 0)
      puts "Wrong: #{game.correct_answer}"
    end
  end

  private

  # * @return [nil]
  # * Displays the options available to the user.
  def display_options
    puts 'To view account information press the number [1]'
    puts 'To begin a new game press the number [2]'
    puts 'To view HIGH SCCORES press the number [3]'
    puts 'To permanently delete your account press the number [4]'
    puts 'To exit the program [5].'
  end

  # @ Returns instance of User.
  # * finds or creates an instance of user based on provided username.
  def find_or_create(username)
    User.find_or_create_by(username: username)
  end

  # * Puts several pieces of information about the current user.
  def access_user_info(user)
    puts "*" * 50
    puts "#{user.username}'s Profile"
    puts "Total Number of Questions Answered Correctly: #{user.total_correct}"
    puts "Current streak: #{user.correct_streak}"
    puts "Longest Streak #{user.longest_streak}"
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
    puts '*****************************************************'
    puts '*****************************************************'
    puts '*****************************************************'
    puts '*****************************************************'
    puts "Thanks for playing, see you soon"
    options(user)
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
    longest_streak
  end
#helper method for update_on_correct_response
  def longest_streak
    total_l_streak = user.longest_streak
    l_streak = user.correct_streak
    if l_streak > total_l_streak
      user.update(id: user.id, longest_streak: l_streak)
    end
  end


  def high_scores
    if user.username.downcase == User.order(longest_streak: :DESC).first.username.downcase
      highest_score
  else
      User.order(longest_streak: :DESC).select {|user| puts "#{user.username} - Score #{user.longest_streak}"}
      sleep(2.5)
      options(user)
  end
end

def highest_score
  high_score_reward
  high_score_you
  puts '*' * 50
  puts "#{user.username.upcase} -- #{user.longest_streak}"
  puts '*' * 50
  sleep(2.5)
  User.order(longest_streak: :DESC).select {|user| puts "#{user.username} - Score #{user.longest_streak}"}
  puts "*" * 50
  options(user)
end

  # * In between method before deleting your account.
  def confirm_delete_account
    puts 'This action is irreversible.'
    puts 'Type \'delete\' to continue or anything else to return to the menu.'
    user_input = gets.chomp
    user_input == 'delete' ? delete_account : options(user)
  end

  # * Deletes the users account from the database then reruns the program
  # * from the beginning.
  def delete_account
    User.delete(user.id)
    exit
  end


  def title_call
    puts "



                            __          ________ _____ _      ____  __  __ ______
                            \\ \\        / /  ____/ ____| |    / __ \\|  \\/  |  ____|
                             \\ \\  /\\ / / | |__ |  |   | |   | |  | | \\  / | |__
                              \\ \\/  \\/ / |  __|| |    | |   | |  | | |\\/| |  __|
                               \\  /\\  /  | |___| |____| |___| |__| | |  | | |____
                                \\/  \\/   |______\\_____|______\\____/|_|  |_|______|


    "
    sleep(1)

    puts "
                                                _________
                                                |__   __|
                                                   | | ___
                                                   | |/ _ \\
                                                   | | (_) |
                                                   |_|\\___/ "
    sleep(1)
    puts "

                      _____ _      _____            _______ _____  _______      _______
                     / ____| |    |_   _|          |__   __|  __ \\|_   _\ \\    / /_   _|   /\\
                    | |    | |      | |    ______     | |  | |__) | | |  \\ \\  / /  | |    /  \\
                    | |    | |      | |   |______|    | |  |  _  /  | |   \\ \\/ /   | |   / /\\ \\
                    | |____| |____ _| |_              | |  | | \\ \\ _| |_   \\  /   _| |_ / ____ \\
                     \\_____|______|_____|             |_|  |_|  \\_\\_____|   \\/   |_____/_/    \\_\\



                                                               "
         end


def high_score_reward
puts  "                                 _         _       _   _
                                | |       | |     | | (_)
  ___ ___  _ __   __ _ _ __ __ _| |_ _   _| | __ _| |_ _  ___  _ __  ___
 / __/ _ \\| '_ \\ / _` | '__/ _` | __| | | | |/ _` | __| |/ _ \\| '_ \\/ __|
| (_| (_) | | | | (_| | | | (_| | |_| |_| | | (_| | |_| | (_) | | | \\__ \\
 \\___\\___/|_| |_|\\__, |_|  \\__,_|\\__|\\__,_|_|\\__,_|\\__|_|\\___/|_| |_|___/
                  __/ |
                 |___/                                                   "



end

def high_score_you
puts " __   _____  _   _      _    ____  _____   _____ _   _ _____
 \\ \\ / / _ \\| | | |    / \  |  _ \| ____| |_   _| | | | ____|
  \\ V / | | | | | |   / _ \\ | |_) |  _|     | | | |_| |  _|
   | || |_| | |_| |  / ___ \\|  _ <| |___    | | |  _  | |___
   |_| \\___/_\\___/_ /_/ _ \\_\\_| \\_\\_____|  _|_| |_|_|_|_____|
    | | | |_ _/ ___| | | / ___| / ___/ _ \\|  _ \\| ____|
    | |_| || | |  _| |_| \\___ \\| |  | | | | |_) |  _|
    |  _  || | |_| |  _  |___) | |__| |_| |  _ <| |___
    |_| |_|___\\____|_| |_|____/ \\____\\___/|_| \\_\\_____|
                                                             "



end









end
