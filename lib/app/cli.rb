class CLI

  def self.greeting
    puts "Welcome to Adam, Jake, and Oscar's movie selector! Please select a genre you'd like to to search for:"
  end

  def self.get_user_input
    user_input = gets.chomp.downcase

    response = RestClient.get("http://www.omdbapi.com/?s=#{user_input}&apikey=a2d3299b")

    return_data = JSON.parse(response)

    puts return_dataf
  end

  def self.start
    greeting
    get_user_input
  end

end
