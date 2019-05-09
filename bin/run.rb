require_relative '../config/environment'

ActiveRecord::Base.logger = nil


cli = CommandLineInterface.new
user = cli.greet
cli.options(user)
