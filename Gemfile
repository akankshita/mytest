# A sample Gemfile
source "http://rubygems.org"
source "http://gems.github.com"
ruby '1.8.7'
# gem "rails"
gem "rails", "2.3.11"
gem "pg"
gem "will_paginate", "2.3.11"
gem "aws-s3"
#gem "rack", "9"
gem "cancan"
gem "authlogic"
gem "rdoc"
gem "td"
gem 'newrelic_rpm'  

group :production do
  gem "ruby-debug"
end

group :development do
   gem "nifty-generators"
end

group :cucumber do
  gem 'cucumber-rails', '>=0.3.2'
  gem 'database_cleaner', '>=0.5.0'
  gem 'webrat', '>=0.7.0'
end

group :test do
  #cucumber requirements
  gem "ruby-debug"
  gem "rspec", ">=1.2.2"
  gem "rspec-rails", ">=1.2.2"
  gem "webrat", ">=0.7.0"
  gem "cucumber", ">=0.3.2"
  gem "cucumber-rails", ">=0.3.2"
  gem 'database_cleaner', '>=0.5.0'
  gem 'rcov'
end
