class Smartfm::Sentence < Smartfm::Base
  ATTRIBUTES = [:sound, :image, :square_image, :text, :language, :id, :transliterations, :translations, :item, :list]
  READONLY_ATTRIBUTES = [:id]
  attr_accessor *(ATTRIBUTES - READONLY_ATTRIBUTES)
  attr_reader *READONLY_ATTRIBUTES

  def self.recent(params = {})
    hash = Smartfm::RestClient::Sentence.recent(params)
    self.deserialize(hash) || []
  end

  def self.find(sentence_id, params = {})
    params[:id] = sentence_id
    hash = Smartfm::RestClient::Sentence.find(params)
    self.deserialize(hash)
  end

  def self.matching(keyword, params = {})
    params[:keyword] = keyword
    hash = Smartfm::RestClient::Sentence.matching(params)
    self.deserialize(hash) || []
  end

  def self.create(auth, params = {})
    self.new(params).save(auth)
  end

  def initialize(params = {})
    params[:translations] = [params[:translation]] if params[:translation]
    params[:transliterations] = [params[:transliteration]] if params[:transliteration]
    @id               = params[:id]
    @item             = params[:item]
    @list             = params[:list]
    @sound            = params[:sound]
    @image            = params[:image]
    @square_image     = params[:square_image]
    @text             = params[:text]
    @language         = params[:language]
    @transliterations = params[:transliterations]
    @translations     = self.deserialize(params[:translations], :as => Smartfm::Sentence)
  end

  def save(auth)
    begin
      sentence_id = Smartfm::RestClient::Sentence.create(auth, self.to_post_data)
    rescue
      return false
    end
    Smartfm::Sentence.find(sentence_id)
  end

  def add_image(auth, params)
    post_params = if params.is_a?(String)
      {'image[url]' => params}
    else
      {'image[url]' => params[:url], 'image[list_id]' => params[:list_id]}.merge(attribution_params(params[:attribution]))
    end
    Smartfm::RestClient::Sentence.add_image(auth, post_params.merge(:id => self.id))
  end

  def add_sound(auth, params)
    post_params = if params.is_a?(String)
      {'sound[url]' => params}
    else
      {'sound[url]' => params[:url], 'sound[list_id]' => params[:list_id]}.merge(attribution_params(params[:attribution]))
    end
    Smartfm::RestClient::Sentence.add_sound(auth, post_params.merge(:id => self.id))
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

  def attribution_params(attr_params)
    return {} unless attr_params
    {'attribution[medias_entity]'           => attr_params[:media_entity],
     'attribution[author]'                  => attr_params[:author],
     'attribution[author_url]'              => attr_params[:author_url],
     'attributions[attribution_license_id]' => attr_params[:attribution_license_id] }
  end

end