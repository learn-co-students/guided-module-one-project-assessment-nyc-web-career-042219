require 'bundler'
Bundler.require
require 'rest-client'
require 'JSON'
require 'catpix'
# require 'colorize'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
