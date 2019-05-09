require_relative '../config/environment'

cli = CommandLineInterface.new
user = cli.greet
cli.options(user)
