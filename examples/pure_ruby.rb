require 'rubygems'
require 'iknow'

Iknow::Config.init do |conf|
  conf.api_key = "" # Set your iKnow! API key, here.
  conf.host    = "api.iknow.co.jp"
end

please_get_api_key =<<EOS
This example needs your own iKnow! API key.
(for only Iknow::Item.extract example)

You can get iKnow! API key at iKnow! Developers.
iKnow! Developers (http://developer.iknow.co.jp/)

Thanks!
EOS

raise ArgumentError.new(please_get_api_key) if Iknow::Config.instance.api_key == ''

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