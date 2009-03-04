require 'rubygems'
require 'smartfm'
require 'oauth/consumer'

Smartfm::Config.init do |conf|
  conf.api_host              = 'api.smart.fm'
  conf.api_key               = '' # 'SET_YOUR_API_KEY'
  conf.oauth_consumer_key    = '' # 'SET_YOUR_OAUTH_CONSUMER_KEY'
  conf.oauth_consumer_secret = '' # 'SET_YOUR_OAUTH_CONSUMER_SECRET'
  conf.oauth_http_method     = :post
  conf.oauth_scheme          = :header
  conf.timeout               = 15
end

# Edit here
OAUTH_ACCESS_TOKEN = ''
OAUTH_ACCESS_TOKEN_SECRET = ''

# Edit here
SMARTFM_USERNAME = ''
SMARTFM_PASSWORD = ''

please_get_api_key =<<EOS
This example needs your own smart.fm API key.
(for only Smartfm::Item.extract example)

You can get smart.fm API key at smart.fm Developers.
smart.fm Developers (http://developer.smart.fm/)

Thanks!
EOS

if Smartfm::Config.api_key == ''
  raise ArgumentError.new(please_get_api_key)
end


###########################
## WITHOUT AUTHORIZATION ##
###########################

puts "WITHOUT AUTHORIZATION"

## User API
puts "# User API Calls"
@user = Smartfm::User.find('kirk')
@user.items(:include_sentences => true)
@user.lists
@user.friends
@user.study.results
@user.study.total_summary
@matched_users = Smartfm::User.matching('matake')

## List API
puts "# List API Calls"
@recent_lists = Smartfm::List.recent
@list = Smartfm::List.find(31509, :include_sentences => true, :include_items => true)
@list.items
@list.sentences
@matched_lists = Smartfm::List.matching("イタリア語であいさつ")

## Item API
puts "# Item API Calls"
@recent_items = Smartfm::Item.recent(:include_sentences => true)
@item = Smartfm::Item.find(437525)
@matched_items = Smartfm::Item.matching('record', :include_sentences => true)
@items = Smartfm::Item.extract("sometimes, often, electrical")
@items.first.sentences

## Sentence API
puts "# Sentence API Calls"
@recent_sentences = Smartfm::Sentence.recent
@sentence = Smartfm::Sentence.find(312271)
@matched_sentences = Smartfm::Sentence.matching('record')


########################
## WITH AUTHORIZATION ##
########################

auth = case
  when !OAUTH_ACCESS_TOKEN.empty?
    if Smartfm::Config.oauth_consumer_key.empty? or Smartfm::Config.oauth_consumer_secret.empty?
      raise ArgumentError.new("oauth_consumer_key and oauth_consumer_secret are required")
    end
    Smartfm::Auth.new(:token => OAUTH_ACCESS_TOKEN, :secret => OAUTH_ACCESS_TOKEN_SECRET)
  when SMARTFM_USERNAME != ''
    Smartfm::Auth.new(:username => SMARTFM_USERNAME, :password => SMARTFM_PASSWORD)
  else
    nil
  end
unless auth
  puts "Skip calls which require authentication"
  exit
else
  puts "## WITH AUTHORIZATION :: #{auth.mode}"
end

## List API
puts "# List API"
@list = Smartfm::List.create(auth, :title => 'smart.fm gem test', :description => 'A list for smart.fm gem test')
@list.add_item(auth, Smartfm::Item.find(437525))
@list.delete_item(auth, @list.items.first)
@list.delete(auth)

## Item API
puts "# Item API"
@item = Smartfm::Item.create(auth, :cue => {:text => 'hello world! 2', :language => 'en', :part_of_speech => 'E'}, 
                                       :response => {:text => 'ハローワールド！', :language => 'ja'})
@item.add_image(auth, 'http://farm4.static.flickr.com/3276/3102381796_a33c1ffdf1.jpg')
@item.add_sound(auth, 'http://matake.jp/download/hello_world.mp3')
@item.add_tags(auth, 'sample', 'programming')

## Sentence API
puts "# Sentence API"
@sentence = Smartfm::Sentence.create(auth, :text => 'Hello World!', :item => Smartfm::Item.matching('hello world').first)
@sentence.add_image(auth, 'http://farm4.static.flickr.com/3276/3102381796_a33c1ffdf1.jpg')
@sentence.add_sound(auth, 'http://matake.jp/download/hello_world.mp3')