source 'https://rubygems.org'
ruby '2.4.1'

group :production do
  gem 'pg' # Heroku database
  gem 'rails_12factor' # Heroku support
end

# Default Rails gems
gem 'rails', "5.1.6"
gem 'uglifier' # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails' # Use CoffeeScript for .js.coffee assets and views
gem 'jquery-rails' # Use jquery as the JavaScript library
gem 'turbolinks' # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'sass-rails'# Use SCSS for stylesheets
gem 'bootstrap-sass' # Twitter Bootstrap front-end framework
gem 'bcrypt' # To use ActiveModel has_secure_password


# Non-default gems
gem 'faye' #allow sending messages back to users
gem 'newrelic_rpm' #3rd party application for monitoring and status info
gem 'private_pub' #filter faye messages for only some recipients
gem 'ruby-progressbar'
gem 'state_machine' #may not be used anymore
gem 'omniauth-identity' #allow logging in locally
gem 'omniauth-facebook' #allow logins using facebook
gem 'omniauth-twitter' #allow logins using twitter
gem 'thin' #hosts faye
gem 'jquery-datatables-rails' #for easy pagination and searching in admin page
gem 'jquery-ui-rails' #for easy pagination and searching in admin page
gem 'responders'

#depreciated gems FIXME
#gem 'protected_attributes'

group :development do
  gem 'annotate'
  gem 'foreman'
  gem 'pry'
end

group :development, :test do
  gem 'sqlite3' # Development database
  gem 'rspec-rails' # Run rake tests in development
  gem 'therubyracer' # Javascript runtime for development
end

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
