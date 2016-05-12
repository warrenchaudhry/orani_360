source 'https://rubygems.org'
ruby '2.3.0'

# Base
gem 'rails', '4.2.5.2'
gem 'pg', group: [:staging, :production]
gem 'rails_12factor', group: :production
gem 'figaro'
gem 'responders', '~> 2.0'
gem 'execjs'
gem 'therubyracer', platforms: :ruby
gem 'coffee-script-source', '~>1.10.0'
gem 'sprockets-rails', :require => 'sprockets/railtie'
gem 'puma'
gem 'foreman'
gem 'aws-s3', '~> 0.6.3'
gem 'aws-sdk', '~> 1.36.1'



# Front end
gem 'sass-rails', '~> 5.0'
gem 'bootstrap-sass'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'slim-rails'
gem 'simple_form'
gem 'font-awesome-sass'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'nested_form'
gem 'countries', '~> 0.11.4'
gem 'country_select', '~> 2.2.0'
gem 'bootstrap-datepicker-rails'
gem 'data-confirm-modal', github: 'ifad/data-confirm-modal'
gem 'validates_timeliness', '~> 4.0'


# Code dependencies
gem 'sorcery'
gem 'rolify'
gem 'friendly_id', '~> 5.1.0'
gem 'iconv'
gem 'paperclip', '~> 4.3.5'
gem 'ckeditor', github: 'galetahub/ckeditor'
gem 'httparty'




gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'



# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'sqlite3'
  gem 'pry-rails'
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'byebug'
  gem 'rspec-rails', '~> 3.0'
  gem 'shoulda-matchers', '~> 3.1', require: false
end

group :test do
  gem 'factory_girl_rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views


  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  #gem 'spring'
end
