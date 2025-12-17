require File.expand_path('../config/environment', __dir__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'factory_bot_rails'
require 'webmock/rspec'

# Patch for Rails 7.1 + Ruby 3.1 ActionView ERB constant issue
ActiveSupport.on_load(:action_view) do
  handler = ActionView::Template::Handlers::ERB

  unless handler.const_defined?(:ENCODING_FLAG)
    handler.const_set(:ENCODING_FLAG, '[+-]'.freeze)
  end
end

WebMock.disable_net_connect!(
  allow_localhost: true
)

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
