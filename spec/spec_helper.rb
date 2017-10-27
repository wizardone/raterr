require 'simplecov'
SimpleCov.start
require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov
require 'bundler/setup'
require 'timecop'
require 'raterr'

Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    if ENV["RATERR_TEST_REDIS"]
      Raterr.store = Redis.new
      Raterr.store.flushall
    elsif ENV["RATERR_TEST_HASH"]
      Raterr.store = Hash.new
    end
  end
end
