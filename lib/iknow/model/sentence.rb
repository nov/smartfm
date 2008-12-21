class Iknow::Sentence < Iknow::Base
  ATTRIBUTES = [:sound, :image, :text, :language, :id, :transliterations, :translations, :item, :list]
  READONLY_ATTRIBUTES = [:id]
  attr_accessor *(ATTRIBUTES - READONLY_ATTRIBUTES)
  attr_reader *READONLY_ATTRIBUTES

  def self.recent(params = {})
    hash = Iknow::RestClient::Sentence.recent(params)
    self.deserialize(hash) || []
  end

  def self.find(sentence_id, params = {})
    params[:id] = sentence_id
    hash = Iknow::RestClient::Sentence.find(params)
    self.deserialize(hash)
  end

  def self.matching(keyword, params = {})
    params[:keyword] = keyword
    hash = Iknow::RestClient::Sentence.matching(params)
    self.deserialize(hash) || []
  end

  def self.create(iknow_auth, params = {})
    self.new(params).save(iknow_auth)
  end

  def initialize(params = {})
    params[:translations] = [params[:translation]] if params[:translation]
    params[:transliterations] = [params[:transliteration]] if params[:transliteration]
    @id       = params[:id]
    @item     = params[:item]
    @list     = params[:list]
    @sound    = params[:sound]
    @image    = params[:image]
    @text     = params[:text]
    @language = params[:language]
    @transliterations = params[:transliterations]
    @translations = self.deserialize(params[:translations], :as => Iknow::Sentence)
  end

  def save(iknow_auth)
    begin
      sentence_id = Iknow::RestClient::Sentence.create(iknow_auth, self.to_post_data)
    # rescue
    #   return false
    end
    Iknow::Sentence.find(sentence_id)
  end

  def add_image(iknow_auth, params)
    post_params = if params.is_a?(String)
      {'image[url]' => params,}
    else
      {'image[url]' => params[:url],
       'image[list_id]' => params[:list_id] }
    end
    Iknow::RestClient::Sentence.add_image(iknow_auth, post_params.merge(:id => self.id))
  end

  def add_sound(iknow_auth, params)
    post_params = if params.is_a?(String)
      {'sound[url]' => params,}
    else
      {'sound[url]' => params[:url],
       'sound[list_id]' => params[:list_id] }
    end
    Iknow::RestClient::Sentence.add_sound(iknow_auth, post_params.merge(:id => self.id))
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
    self.translations.first rescue nil
  end

  def transliteration
    self.transliterations.first rescue nil
  end

end