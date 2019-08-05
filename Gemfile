# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'codebreaker_ai', git: 'https://github.com/Kuller86/codebreaker_ai', branch: 'dev'

gem 'i18n'
gem 'haml', '~> 5.1'
gem 'rack', '~> 2.0'

group :development do
  gem 'bundle-audit', '~> 0.1.0'
  gem 'fasterer', '~> 0.5.1'
  gem 'overcommit', '~> 0.48.0'
  gem 'pry', '~> 0.12.2'
  gem 'rubocop', '~> 0.69.0'
  gem 'rubocop-performance', '~> 1.3'
end

group :test do
  gem 'rspec', '~> 3.8'
  gem 'rubocop-rspec', '~> 1.33'
  gem 'simplecov', '~> 0.16.1'
end
