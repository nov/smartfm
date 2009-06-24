class Smartfm::Sentence < Smartfm::Base
  ATTRIBUTES = [:sound, :image, :square_image, :text, :language, :id, :transliterations, :translations, :item, :list, :user]
  READONLY_ATTRIBUTES = [:id, :user]
  attr_accessor *(ATTRIBUTES - READONLY_ATTRIBUTES)
  attr_reader *READONLY_ATTRIBUTES

  include Smartfm::PublicContent
  include Smartfm::MediaSupport
  include Smartfm::ActsAsLikable

  def self.rest_client; Smartfm::RestClient::Sentence; end
  def rest_client; self.class.rest_client; end

  def initialize(params = {})
    params[:translations]     = Array(params[:translation])     if params[:translation]
    params[:transliterations] = Array(params[:transliteration]) if params[:transliteration]
    @id               = params[:id].to_i if params[:id]
    @item             = params[:item]
    @list             = params[:list]
    @sound            = params[:sound]
    @image            = params[:image]
    @square_image     = params[:square_image]
    @text             = params[:text]
    @language         = params[:language]
    @transliterations = params[:transliterations]
    @translations     = self.deserialize(params[:translations], :as => Smartfm::Sentence)
    @user             = self.deserialize(params[:user],         :as => Smartfm::User)
  end

  protected

  def to_post_data
    self.validate
    post_data = {
      'item_id' => self.item.id,
      'sentence[text]' => self.text
    }
    # Optional attributes
    if self.list
      post_data['sentence[list_id]'] = self.list.id
    end
    [:language, :transliteration].each do |key|
      if self.send("#{key}")
        post_data["sentence[#{key}]"] = self.send("#{key}")
      end
    end
    if self.translation
      [:text, :language, :transliteration].each do |key|
        if self.translation.send("#{key}")
          post_data["translation[#{key}]"] = self.translation.send("#{key}")
        end
      end
    end
    post_data
  end

  def validate
    raise ArgumentError.new("Item is required.") unless self.item
    raise ArgumentError.new("Sentence text is required.") if self.text.nil? or self.text.empty?
  end

  def translation
    self.translations.first if self.translations
  end

  def transliteration
    self.transliterations.first if self.transliterations
  end

end