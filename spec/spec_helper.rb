begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end
$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), "..", "lib")))
require File.join(File.dirname(__FILE__), '..', 'lib', 'smartfm')

def be_a(klass)
  be_is_a(klass)
end

def rand_string(length = 100)
  chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
  Array.new(length){ chars[rand(chars.size)] }.join
end