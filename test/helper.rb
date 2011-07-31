require 'rubygems'
require 'bundler'
require 'active_support'
require 'pry'
require 'mongo_mapper'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'clortho'

MongoMapper.database = 'testing_clortho'

require 'models/post'

class Test::Unit::TestCase
end

@lipsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus porttitor, ipsum a commodo aliquet, 
           velit ligula porttitor eros, sit amet consequat purus massa sit amet quam. Aliquam tempus magna faucibus 
           lacus ultricies rhoncus. In ut metus purus, at venenatis est. Donec vel elementum turpis. Nullam feugiat 
           massa quis elit egestas."