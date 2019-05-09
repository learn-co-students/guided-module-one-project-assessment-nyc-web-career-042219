# Holds various designs elements to be brought into the CLI.
class Design
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
                     / ____| |    |_   _|          |__   __|  __ \\|_   _\ \\    / /_   _|    /\\
                    | |    | |      | |    ______     | |  | |__) | | |  \\ \\  / /  | |    /  \\
                    | |    | |      | |   |______|    | |  |  _  /  | |   \\ \\/ /   | |   / /\\ \\
                    | |____| |____ _| |_              | |  | | \\ \\ _| |_   \\  /   _| |_ / ____ \\
                     \\_____|______|_____|             |_|  |_|  \\_\\_____|   \\/   |_____/_/    \\_\\



         "
  end

  def loading_bar
    puts 'LOADING...'
    spinner = Enumerator.new do |e|
      loop do
        e.yield '|'
        e.yield '/'
        e.yield '-'
        e.yield '\\'
      end
    end

    1.upto(100) do |i|
      progress = '=' * (i/5) unless i < 5
      printf("\rCombined: [%-20s] %d%% %s", progress, i, spinner.next)
      sleep(0.1)
    end
  end

  # @return [nil]
  def print_asterisks
    puts
    puts '*' * 100
    puts
  end

end