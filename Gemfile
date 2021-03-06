source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

gem 'rails', '~> 5.2.3'

# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster.
gem 'turbolinks', '~> 5'
# Nokogiri (鋸) is an HTML, XML, SAX, and Reader parser.
gem 'nokogiri', '>= 1.10.8'
# Build JSON APIs with ease.
gem 'jbuilder', '~> 2.5'
# Automate jQuery with Rails.
gem 'jquery-rails'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
# A modern CSS framework based on Flexbox. https://bulma.io/
gem 'bulma-rails', '~> 0.7.5'
# Flexible authentication solution for Rails with Warden.
gem 'devise'
# A file uploader for images.
gem 'carrierwave'
# A lightweight image manipulator.
gem 'mini_magick'
# Securely configure environment variables.
gem 'figaro'
# A pagination library for rails.
gem 'will_paginate'
# Integrate the Bulma pagination component.
gem 'will_paginate-bulma'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Generate random fake data.
  gem 'faker', :git => 'https://github.com/faker-ruby/faker.git', :branch => 'master'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Preview emails in the browser.
  gem 'letter_opener'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'webdrivers', '~> 4.0'
  # Creates customizable Minitest output formats
  gem 'minitest', '~> 5.11.3'
  gem 'minitest-reporters', '~> 1.3.8'
  # Monitors changes in the filesystem and automatically runs tests.
  gem 'guard'
  gem 'guard-minitest'
end

group :production do
  # Image upload with cloud services.
  gem 'fog'
  # AWS S3 storage service.
  gem 'aws-sdk-s3'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
