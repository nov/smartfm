require 'rubygems'
require 'iknow'

Iknow::Config.init do |conf|
  conf.api_key               = 'yarpp3tnrk77qx9vwwjnpt42'
  conf.oauth_consumer_key    = ''
  conf.oauth_consumer_secret = ''
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
@user = Iknow::User.find('matake')
@user.items
@user.lists
@user.friends
@user.study_results
@matchied_users = Iknow::User.matching('matake')

# ## List API
@recent_lists = Iknow::List.recent
@matchied_lists = Iknow::List.matching("遺伝的アルゴリズム")
@ga_list.first.items
@ga_list.first.sentences

# ## Item API
@recent_items = Iknow::Item.recent
@matchied_items = Iknow::Item.matching('record')
@items = Iknow::Item.extract("sometimes, often, electrical")
@items.first.sentences

## Sentence API
@recent_sentences = Iknow::Sentence.recent
@matchied_sentences = Iknow::Sentence.matching('record')