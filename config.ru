require_relative 'dependecy'

use Rack::Session::Pool
use Rack::Reloader

use Rack::Static, urls: ['/app/assets', '/node_modules'], root: './'

run Application

