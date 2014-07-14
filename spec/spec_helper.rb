ENV["RAILS_ENV"] = "test"

# Allows loading of an environment config based on the environment
redmine_root = ENV["REDMINE_ROOT"] || File.dirname(__FILE__) + "/../../.."
require File.expand_path(redmine_root + "/config/environment")
require 'rspec/rails'
require 'rspec/autorun'
require 'database_cleaner'
require 'factory_girl'

Dir["#{File.dirname(__FILE__)}/factories/*.rb"].each {|file| require file }

RSpec.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = false
  config.use_instantiated_fixtures  = false
  config.fixture_path = File.expand_path(redmine_root + '/test/fixtures/')
  config.global_fixtures = :issue_statuses, :roles, :trackers, :enumerations

  config.include FactoryGirl::Syntax::Methods

  config.before :suite do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with :transaction
  end

  config.before :each do
    DatabaseCleaner.start
    Role.find_by_name('Manager').add_permission! :centos_rate, :view_ratings
    Role.find_by_name('Developer').add_permission! :centos_be_rated, :view_ratings
  end

  config.after :each do
    DatabaseCleaner.clean
  end
end
