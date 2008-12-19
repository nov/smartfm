require 'rubygems'
require 'iknow'
require 'oauth/consumer'

Iknow::Config.init do |conf|
  conf.api_host              = 'api.iknow.co.jp'
  conf.api_key               = '' # 'SET_YOUR_API_KEY'
  conf.oauth_consumer_key    = '' # 'SET_YOUR_OAUTH_CONSUMER_KEY'
  conf.oauth_consumer_secret = '' # 'SET_YOUR_OAUTH_CONSUMER_SECRET'
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

## User API
@user = Iknow::User.find('kirk')
@user.items(:include_sentences => true)
@user.lists
@user.friends
@user.study.results
@user.study.total_summary
@matched_users = Iknow::User.matching('matake')

## List API
@recent_lists = Iknow::List.recent
@list = Iknow::List.find(31509, :include_sentences => true, :include_items => true)
@list.items
@list.sentences
@matched_lists = Iknow::List.matching("イタリア語であいさつ")

## Item API
@recent_items = Iknow::Item.recent(:include_sentences => true)
@item = Iknow::Item.find(437525)
@matched_items = Iknow::Item.matching('record', :include_sentences => true)
@items = Iknow::Item.extract("sometimes, often, electrical")
@items.first.sentences

## Sentence API
@recent_sentences = Iknow::Sentence.recent
@sentence = Iknow::Sentence.find(312271)
@matched_sentences = Iknow::Sentence.matching('record')


########################
## WITH AUTHORIZATION ##
########################

iknow_auth = case
  when OAUTH_ACCESS_TOKEN != ''
    if Iknow::Config.oauth_consumer_key == '' or Iknow::Config.oauth_consumer_secret == ''
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
end

## List API

@list = Iknow::List.create(iknow_auth, :title => 'iKnow! gem test', :description => 'A list for iKnow! gem test')
@list.add_item(iknow_auth, Iknow::Item.find(437525))
unless OAUTH_ACCESS_TOKEN.empty?
  # A kind of weird, only with basic auth...
  @list.delete_item(iknow_auth, @list.items.first)
end
@list.delete(iknow_auth)