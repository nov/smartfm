class Smartfm::List < Smartfm::Base
  ATTRIBUTES = [:id, :title, :description, :icon, :square_icon, :item_count, :user_count, :iknow, :dictation, :brainspeed,
                :language, :translation_language, :list_type, :transcript, :embed,
                :tags, :media_entry, :author, :author_id, :author_url, :attribution_license_id,
                :items, :sentences]
  READONLY_ATTRIBUTES = [:id, :icon, :item_count, :user_count, :iknow, :dictation, :brainspeed]
  attr_accessor *(ATTRIBUTES - READONLY_ATTRIBUTES)
  attr_reader   *READONLY_ATTRIBUTES

  class Application < Smartfm::Base
    ATTRIBUTES = [:application, :list_id, :lang]
    attr_reader *ATTRIBUTES

    def initialize(params = {})
      @application  = params[:application]
      @list_id      = params[:list_id]
      @lang         = params[:lang]
    end
    def url
      "http://smart.fm/flash?swf=#{self.name}&course_id=#{self.list_id}&lang=#{self.lang}"
    end
  end

  def self.recent(params = {})
    hash = Smartfm::RestClient::List.recent(params)
    self.deserialize(hash) || []
  end

  def self.find(list_id, params = {})
    params[:id] = list_id
    hash = Smartfm::RestClient::List.find(params)
    self.deserialize(hash)
  end

  def self.matching(keyword, params = {})
    params[:keyword] = keyword
    hash = Smartfm::RestClient::List.matching(params)
    self.deserialize(hash) || []
  end

  def self.create(auth, params = {})
    self.new(params).save(auth)
  end

  def self.delete(list_id)
    self.find(list_id).delete
  end

  def initialize(params = {})
    @id          = (params[:id].to_i rescue nil)
    @title       = params[:title]
    @description = params[:description]
    @icon        = params[:icon]
    @square_icon = params[:square_icon]
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
    @items     = self.deserialize(params[:items],     :as => Smartfm::Item)
    @sentences = self.deserialize(params[:sentences], :as => Smartfm::Sentence)
  end

  def items(params = {})
    hash = Smartfm::RestClient::List.items(params.merge(:id => self.id))
    self.deserialize(hash, :as => Smartfm::Item) || []
  end

  def sentences(params = {})
    hash = Smartfm::RestClient::List.sentences(params.merge(:id => self.id))
    self.deserialize(hash, :as => Smartfm::Sentence) || []
  end

  def save(auth)
    begin
      list_id = Smartfm::RestClient::List.create(auth, self.to_post_data)
    rescue
      return false
    end
    Smartfm::List.find(list_id)
  end

  def delete(auth)
    Smartfm::RestClient::List.delete(auth, {:id => self.id})
  end
  alias_method :destroy, :delete

  def add_item(auth, item)
    Smartfm::RestClient::List.add_item(auth, {:list_id => self.id, :id => item.id})
  end

  def delete_item(auth, item)
    Smartfm::RestClient::List.delete_item(auth, {:list_id => self.id, :id => item.id})
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