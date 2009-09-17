class Smartfm::List < Smartfm::Base
  ATTRIBUTES = [:id, :title, :description, :icon, :square_icon, :items_count, :users_count, :likes_count,
                :iknow, :dictation, :brainspeed, :language, :translation_language, :item_type, :transcript,
                :embed, :tags, :media_entry, :attribution_license_id, :items, :sentences, :user]
  READONLY_ATTRIBUTES = [:id, :icon, :items_count, :users_count, :likes_count, :iknow, :dictation, :brainspeed, :user]
  attr_accessor *(ATTRIBUTES - READONLY_ATTRIBUTES)
  attr_reader   *READONLY_ATTRIBUTES

  include Smartfm::PublicContent
  include Smartfm::ActsAsLikable

  def self.rest_client; Smartfm::RestClient::List; end
  def rest_client; self.class.rest_client; end

  class Application < Smartfm::Base
    ATTRIBUTES = [:application, :available, :progress, :list_id, :lang, :href]
    attr_reader *ATTRIBUTES

    def initialize(params = {})
      @application = case
        when params[:iknow]      then :iknow
        when params[:dictation]  then :dictation
        when params[:brainspeed] then :brainspeed
        end
      @available = params[self.application][:available]
      @progress  = params[self.application][:progress]
      @href      = params[self.application][:href]
      @list_id   = params[:list_id]
      @lang      = params[:lang]
    end

    def available?
      self.available
    end
  end

  def initialize(params = {})
    @id          = params[:id].to_i if params[:id]
    @title       = params[:title]
    @description = params[:description]
    @icon        = params[:icon]
    @square_icon = params[:square_icon]
    @items_count = params[:items_count].to_i if params[:items_count]
    @users_count = params[:users_count].to_i if params[:users_count]
    @likes_count = params[:likes_count].to_i if params[:likes_count]
    @language    = params[:language]
    @translation_language = params[:translation_language]
    if @id and @translation_language
      common_settings = {:list_id => @id, :lang => @translation_language}
      @iknow      = Application.new(common_settings.merge(:iknow      => params[:iknow]))
      @dictation  = Application.new(common_settings.merge(:dictation  => params[:dictation]))
      @brainspeed = Application.new(common_settings.merge(:brainspeed => params[:brainspeed]))
    end
    @item_type   = params[:item_type]
    @transcript  = params[:transcript]
    @embed       = params[:embed]
    @tags        = params[:tags]
    @media_entry = params[:media_entry]
    @attribution_license_id = params[:attribution_license_id].to_i if params[:attribution_license_id]
    @items       = self.deserialize(params[:items],     :as => Smartfm::Item)
    @sentences   = self.deserialize(params[:sentences], :as => Smartfm::Sentence)
    @user        = self.deserialize(params[:user],      :as => Smartfm::User)
  end

  def items(params = {})
    hash = self.rest_client.items(params.merge(:id => self.id))
    self.deserialize(hash, :as => Smartfm::Item) || []
  end

  def sentences(params = {})
    hash = self.rest_client.sentences(params.merge(:id => self.id))
    self.deserialize(hash, :as => Smartfm::Sentence) || []
  end

  def add_item(auth, item)
    # id is used for item_id only here..
    self.rest_client.add_item(auth, {:list_id => self.id, :id => item.id})
  end

  def delete_item(auth, item)
    self.rest_client.delete_item(auth, {:id => self.id, :item_id => item.id})
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
    [:transcript, :embed, :tags, :item_type].each do |key|
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