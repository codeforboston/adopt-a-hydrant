source 'https://rubygems.org'
ruby '1.9.3'

gem 'rails', '~> 3.2'

gem 'arel'
gem 'devise'
gem 'geokit'
gem 'geocoder'
gem 'haml'
gem 'http_accept_language'
gem 'pg'
gem 'rails_admin'
gem 'strong_parameters'
gem 'validates_formatting_of'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'seed_dumper'
gem 'resque', :git => "https://github.com/resque/resque.git", :branch => "1-x-stable"
gem 'httparty'
gem 'capistrano'
gem 'rvm-capistrano'
gem 'apn_on_rails'

platforms :ruby_18 do
  gem 'fastercsv'
end

group :assets do
  gem 'sass-rails'
  gem 'uglifier'
end

group :production do
  gem 'puma'
end

group :test do
  gem 'coveralls', :require => false
  gem 'simplecov', :require => false
  gem 'sqlite3'
  gem 'webmock'
end
