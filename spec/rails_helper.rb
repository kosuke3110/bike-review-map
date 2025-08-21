# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'capybara/rspec'

# Checks for pending migrations and applies them before tests are run.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

# Require support files
Rails.root.glob('spec/support/**/*.rb').each { |f| require f }

RSpec.configure do |config|
  # Fixtures
  config.fixture_path = Rails.root.join('spec/fixtures').to_s
  config.use_transactional_fixtures = true

  # FactoryBot
  config.include FactoryBot::Syntax::Methods

  # Infer spec type from file location
  config.infer_spec_type_from_file_location!

  # Filter Rails gems from backtraces
  config.filter_rails_from_backtrace!

  # Capybara system test setup
  config.before(:each, type: :system) do |example|
    if example.metadata[:js]
      # JS テストは rack_test では動かないので警告を出す
      skip 'JavaScript は rack_test では動作しません'
    else
      driven_by :rack_test
    end
  end
end
