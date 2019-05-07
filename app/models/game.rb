# == Schema Information
#
# Table name: games
#
#  id          :integer          not null, primary key
#  num_players :integer
#  lead_player :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Game < ActiveRecord::Base
  has_many :usergames
  has_many :users, through: :usergames

  attr_accessor :question_data, :current_question

  #@ Returns an array of question data
  #* Sets the instance of question data so that the questions
  #* can persist for the entire round.
  def set_question_data
    @question_data = call_trivia_api
  end

  #@ Returns a hash of a single question or a string 
  #* sets the instance variable for the current question.
  def set_current_question
    @current_question = next_question
  end
  
  #* puts out the string from @current_question hash.
  # TODO: Find a way to get rid of those annoying HTML symbols.
  def question_string
    puts current_question['question']
  end
  
  #* Formated print of each choice.
  # TODO: Some questions return in empty strting in their incorrect answers
  # TODO: should decide on what to do with them.
  def print_choices
    generate_choices.each_with_index { |choice, index| puts "#{index + 1}. #{choice}" }
  end
  
  #@ [Boolean]
  #@ Choice is a User given response.
  #* Evaluates whether or not the user select choice matches the correct answer. 
  def is_correct?(choice)
    choice == correct_answer
  end
  
  private
  
  #@ Returns a array acquired from parsing the response from the api.
  def call_trivia_api
    res = JSON.parse(RestClient.get("https://opentdb.com/api.php?amount=10"))
    res['results']
  end
  
  #@ string of the correct answer.
  #* Retrieves the correct answer.
  def correct_answer
    current_question['correct_answer']
  end

  #* Helper method that checks if there is anything left in the question_data
  #* instance variable. Pops a question from the question_data instance if 
  #* possible else a string is returned.
  def next_question
    question_data.empty? ? 'No more questions.' : question_data.pop 
  end
  
  #@ Returns an array
  #* Pushes in the correct answers witht he incorrect answers then
  #* shuffles the array.
  def generate_choices
    answers_array = current_question['incorrect_answers'] 
    answers_array << correct_answer unless answers_array.include?(correct_answer)
    answers_array.shuffle
  end
end
