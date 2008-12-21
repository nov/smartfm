#     "iknow": true,
#     "description": "hogehoge",
#     "translation_language": "ja",
#     "dictation": true,
#     "icon": "http://www.iknow.co.jp/assets/courses/m4.jpg",
#     "brainspeed": true,
#     "language": "en",
#     "item_count": 117,
#     "author_id": "Cerego",
#     "user_count": 45056,
#     "author": "Team iKnow!",
#     "title": "\u65c5\u306b\u51fa\u3088\u3046\uff01\uff08\u51fa\u56fd\uff06\u8857\u3092\u6b69\u304f\uff09",
#     "id": 708,
#     "author_url": "http://www.iknow.co.jp/user/Cerego"

class Iknow::List < Iknow::Base
  ATTRIBUTES = [:id, :title, :description, :icon, :item_count, :user_count, :iknow, :dictation, :brainspeed,
                :language, :translation_language, :list_type, :transcript, :embed,
                :tags, :media_entry, :author, :author_id, :author_url, :attribution_license_id,
                :items, :sentences]
  READONLY_ATTRIBUTES = [:id, :icon, :item_count, :user_count, :iknow, :dictation, :brainspeed]
  attr_accessor *(ATTRIBUTES - READONLY_ATTRIBUTES)
  attr_reader   *READONLY_ATTRIBUTES

  class Application
    attr_reader :application, :list_id, :lang
    def initialize(params = {})
      @application  = params[:application]
      @list_id      = params[:list_id]
      @lang         = params[:lang]
    end
    def url
      "http://www.iknow.co.jp/flash?swf=#{self.name}&course_id=#{self.list_id}&lang=#{self.lang}"
    end
  end

  def self.recent(params = {})
    hash = Iknow::RestClient::List.recent(params)
    self.deserialize(hash) || []
  end

  def self.find(list_id, params = {})
    params[:id] = list_id
    hash = Iknow::RestClient::List.find(params)
    self.deserialize(hash)
  end

  def self.matching(keyword, params = {})
    params[:keyword] = keyword
    hash = Iknow::RestClient::List.matching(params)
    self.deserialize(hash) || []
  end

  def self.create(iknow_auth, params = {})
    self.new(params).save(iknow_auth)
  end

  def self.delete(list_id)
    self.find(list_id).delete
  end

  def initialize(params = {})
    @id          = (params[:id].to_i rescue nil)
    @title       = params[:title]
    @description = params[:description]
    @icon        = params[:icon]
    @item_count  = (params[:item_count].to_i rescue nil)
    @user_count  = (params[:user_count].to_i rescue nil)
    @language    = params[:language]
    @translation_language = params[:translation_language]
    if @list_id and @translation_language
      common_settings = {:list_id => @id, :lang => @translation_language}
      @iknow      = Application.new(common_settings.merge(:application => 'iknow'))      if params[:iknow]
      @dictation  = Application.new(common_settings.merge(:application => 'dictation'))  if params[:dictation]
      @brainspeed = Application.new(common_settings.merge(:application => 'brainspeed')) if params[:brainspeed]
    end
    @author      = params[:author]      # display_name or username
    @author_id   = params[:author_id]   # username
    @author_url  = params[:author_url]
    @list_type   = params[:list_type]   # for list creation
    @transcript  = params[:transcript]  # for list creation
    @embed       = params[:embed]       # for list creation
    @tags        = params[:tags]        # for list creation
    @media_entry = params[:media_entry] # for list creation
    @attribution_license_id = params[:attribution_license_id] # for list creation
    @items     = self.deserialize(params[:items],     :as => Iknow::Item)
    @sentences = self.deserialize(params[:sentences], :as => Iknow::Sentence)
  end

  def items(params = {})
    hash = Iknow::RestClient::List.items(params.merge(:id => self.id))
    self.deserialize(hash, :as => Iknow::Item) || []
  end

  def sentences(params = {})
    hash = Iknow::RestClient::List.sentences(params.merge(:id => self.id))
    self.deserialize(hash, :as => Iknow::Sentence) || []
  end

  def save(iknow_auth)
    begin
      list_id = Iknow::RestClient::List.create(iknow_auth, self.to_post_data)
    rescue
      return false
    end
    Iknow::List.find(list_id)
  end

  def delete(iknow_auth)
    Iknow::RestClient::List.delete(iknow_auth, {:id => self.id})
  end
  alias_method :destroy, :delete

  def add_item(iknow_auth, item)
    Iknow::RestClient::List.add_item(iknow_auth, {:list_id => self.id, :id => item.id})
  end

  def delete_item(iknow_auth, item)
    Iknow::RestClient::List.delete_item(iknow_auth, {:list_id => self.id, :id => item.id})
  end

  protected

  def to_post_data
    self.validate
    post_data = {
      'list[name]'                 => self.title,
      'list[description]'          => self.description,
      'list[language]'             => self.language             || 'en',
      'list[translation_language]' => self.translation_language || 'ja'
    }
    # Optional attributes
    if self.list_type
      post_data['list[type]'] = self.list_type
    end
    [ :transcript, :embed, :tags, :media_entry,
      :author, :author_url, :attribution_license_id ].each do |key|
      if self.send("#{key}")
        post_data["list[#{key}]"] = self.send("#{key}")
      end
    end
    post_data
  end

  def validate
    raise ArgumentError.new("List title is required.")       if self.title.nil?       or self.title.empty?
    raise ArgumentError.new("List description is required.") if self.description.nil? or self.description.empty?
  end

end