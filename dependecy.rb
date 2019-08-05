
require 'pry'
require 'yaml'
require 'haml'
require 'i18n'

require 'codebreaker_ai'

require_relative 'app/controllers/base_controller'
require_relative 'app/controllers/default_controller'
require_relative 'app/router'
require_relative 'app/exceptions'

require_relative 'app/application'

Dir[Dir.pwd + "/app/services/**/*.rb"].each { |f| require_relative f }

I18n.load_path << Dir[File.expand_path('app/locales') + '/*.yml']
I18n.config.available_locales = :en