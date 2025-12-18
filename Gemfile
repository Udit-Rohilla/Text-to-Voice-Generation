source "https://rubygems.org"

ruby "3.1.2"

gem "rails", "~> 7.2.3"

gem "pg"
gem "puma"
gem "redis"
gem "sidekiq"

gem "bootsnap", require: false
gem "faraday"
gem "cloudinary"

gem "rack-attack"
gem "rack-cors", "~> 3.0"

gem "dotenv-rails"

group :development, :test do
  gem "rspec-rails", ">= 6.1.0"
  gem "factory_bot_rails"
  gem "webmock"

  gem "rubocop", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "brakeman", require: false
end
