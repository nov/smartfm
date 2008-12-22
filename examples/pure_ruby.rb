require 'rubygems'
require 'iknow'
require 'oauth/consumer'

Iknow::Config.init do |conf|
  conf.api_host              = 'api.iknow.co.jp'
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
IKNOW_USERNAME = ''
IKNOW_PASSWORD = ''

please_get_api_key =<<EOS
This example needs your own iKnow! API key.
(for only Iknow::Item.extract example)

You can get iKnow! API key at iKnow! Developers.
iKnow! Developers (http://developer.iknow.co.jp/)

Thanks!
EOS

if Iknow::Config.api_key == ''
  raise ArgumentError.new(please_get_api_key)
end


###########################
## WITHOUT AUTHORIZATION ##
###########################

puts "WITHOUT AUTHORIZATION"

## User API
puts "# User API Calls"
@user = Iknow::User.find('kirk')
@user.items(:include_sentences => true)
@user.lists
@user.friends
@user.study.results
@user.study.total_summary
@matched_users = Iknow::User.matching('matake')

## List API
puts "# List API Calls"
@recent_lists = Iknow::List.recent
@list = Iknow::List.find(31509, :include_sentences => true, :include_items => true)
@list.items
@list.sentences
@matched_lists = Iknow::List.matching("イタリア語であいさつ")

## Item API
puts "# Item API Calls"
@recent_items = Iknow::Item.recent(:include_sentences => true)
@item = Iknow::Item.find(437525)
@matched_items = Iknow::Item.matching('record', :include_sentences => true)
@items = Iknow::Item.extract("sometimes, often, electrical")
@items.first.sentences

## Sentence API
puts "# Sentence API Calls"
@recent_sentences = Iknow::Sentence.recent
@sentence = Iknow::Sentence.find(312271)
@matched_sentences = Iknow::Sentence.matching('record')


########################
## WITH AUTHORIZATION ##
########################

iknow_auth = case
  when !OAUTH_ACCESS_TOKEN.empty?
    if Iknow::Config.oauth_consumer_key.empty? or Iknow::Config.oauth_consumer_secret.empty?
      raise ArgumentError.new("oauth_consumer_key and oauth_consumer_secret are required")
    end
    Iknow::Auth.new(:token => OAUTH_ACCESS_TOKEN, :secret => OAUTH_ACCESS_TOKEN_SECRET)
  when IKNOW_USERNAME != ''
    Iknow::Auth.new(:username => IKNOW_USERNAME, :password => IKNOW_PASSWORD)
  else
    nil
  end
unless iknow_auth
  puts "Skip calls which require authentication"
  exit
else
  puts "## WITH AUTHORIZATION :: #{iknow_auth.mode}"
end

## List API
puts "# List API"
@list = Iknow::List.create(iknow_auth, :title => 'iKnow! gem test', :description => 'A list for iKnow! gem test')
@list.add_item(iknow_auth, Iknow::Item.find(437525))
@list.delete_item(iknow_auth, @list.items.first)
@list.delete(iknow_auth)

## Item API
puts "# Item API"
@item = Iknow::Item.create(iknow_auth, :cue => {:text => 'hello world! 2', :language => 'en', :part_of_speech => 'E'}, 
                                       :response => {:text => 'ハローワールド！', :language => 'ja'})
@item.add_image(iknow_auth, 'http://farm4.static.flickr.com/3276/3102381796_a33c1ffdf1.jpg')
@item.add_sound(iknow_auth, 'http://matake.jp/download/hello_world.mp3')
@item.add_tags(iknow_auth, 'sample', 'programming')

## Sentence API
puts "# Sentence API"
@sentence = Iknow::Sentence.create(iknow_auth, :text => 'Hello World!', :item => Iknow::Item.matching('hello world').first)
@sentence.add_image(iknow_auth, 'http://farm4.static.flickr.com/3276/3102381796_a33c1ffdf1.jpg')
@sentence.add_sound(iknow_auth, 'http://matake.jp/download/hello_world.mp3')