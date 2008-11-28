require 'rubygems'
require 'iknow'

Iknow::Config.init do |conf|
  conf.api_key               = 'SET_YOUR_API_KEY'
  conf.oauth_consumer_key    = 'SET_YOUR_OAUTH_CONSUMER_KEY'
  conf.oauth_consumer_secret = 'SET_YOUR_OAUTH_CONSUMER_SECRET'
end

please_get_api_key =<<EOS
This example needs your own iKnow! API key.
(for only Iknow::Item.extract example)

You can get iKnow! API key at iKnow! Developers.
iKnow! Developers (http://developer.iknow.co.jp/)

Thanks!
EOS

if Iknow::Config.api_key == ''# or
  # Iknow::Config.oauth_consumer_key == '' or
  # Iknow::Config.oauth_consumer_secret == ''
  raise ArgumentError.new(please_get_api_key)
end

## User API
@user = Iknow::User.find('kirk')
@user.items(:include_sentences => true)
@user.lists
@user.friends
@user.study.results
@user.study.total_results
@matched_users = Iknow::User.matching('matake')

## List API
@recent_lists = Iknow::List.recent
@list = Iknow::List.find(31509, :include_sentences => true, :include_items => true)
@list.items
@list.sentences
@matched_lists = Iknow::List.matching("イタリア語であいさつ")

# puts Iknow::List.find(31509, :include_sentences => true, :include_items => true).inspect

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