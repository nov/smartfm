class Iknow::Item < Iknow::Base
  ATTRIBUTES = [:sentences, :responses, :cue, :id, :list]
  READONLY_ATTRIBUTES = [:sentences, :responses, :cue, :id]
  attr_accessor *(ATTRIBUTES - READONLY_ATTRIBUTES)
  attr_reader *READONLY_ATTRIBUTES

  class Response
    ATTRIBUTES = [:text, :text_with_character, :type, :language]
    READONLY_ATTRIBUTES = [:type]
    attr_accessor *(ATTRIBUTES - READONLY_ATTRIBUTES)
    attr_reader *READONLY_ATTRIBUTES
    
    def initialize(params = {})
      @text     = params[:text]
      @type     = params[:type]
      @language = params[:language]
    end
  end

  class Cue
    ATTRIBUTES = [:text, :sound, :part_of_speech, :language]
    READONLY_ATTRIBUTES = [:sound]
    attr_accessor *(ATTRIBUTES - READONLY_ATTRIBUTES)
    attr_reader *READONLY_ATTRIBUTES
    
    def initialize(params = {})
      @text           = params[:text]
      @sound          = params[:sound]
      @part_of_speech = params[:part_of_speech]
      @language       = params[:language]
    end
  end

  def self.recent(params = {})
    hash = Iknow::RestClient::Item.recent(params)
    self.deserialize(hash) || []
  end

  def self.find(item_id, params = {})
    params[:id] = item_id
    hash = Iknow::RestClient::Item.find(params)
    self.deserialize(hash)
  end

  def self.matching(keyword, params = {})
    params[:keyword] = keyword
    hash = Iknow::RestClient::Item.matching(params)
    self.deserialize(hash) || []
  end

  def self.extract(text, params = {})
    params[:text] = text
    hash = Iknow::RestClient::Item.extract(params)
    self.deserialize(hash) || []
  end

  def self.create(iknow_auth, params = {})
    self.new(params).save(iknow_auth)
  end

  def initialize(params = {})
    params[:responses] = [params[:response]] if params[:response]
    @id        = params[:id].to_i
    @list      = params[:list]
    @cue       = self.deserialize(params[:cue], :as => Iknow::Item::Cue)
    @responses = self.deserialize(params[:responses], :as => Iknow::Item::Response)
    @sentences = self.deserialize(params[:sentences], :as => Iknow::Sentence)
  end

  def save(iknow_auth)
    begin
      item_id = Iknow::RestClient::Item.create(iknow_auth, self.to_post_data)
    rescue
      return false
    end
    Iknow::Item.find(item_id)
  end

  def add_image(iknow_auth, params)
    post_params = if params.is_a?(String)
      { 'image[url]' => params }
    else
      image_params = { 
        'image[url]'     => params[:url],
        'image[list_id]' => params[:list_id]
      }
      if params[:attribution]
        attribution_params = { 
          'attribution[media_entity]'           => params[:attribution][:media_entity],
          'attribution[author]'                 => params[:attribution][:media_entity],
          'attribution[author_url]'             => params[:attribution][:media_entity],
          'attribution[attribution_license_id]' => params[:attribution][:media_entity]
        }
        image_params.merge(attribution_params)
      else
        image_params
      end
    end
    Iknow::RestClient::Item.add_image(iknow_auth, post_params.merge(:id => self.id))
  end

  def add_sound(iknow_auth, params)
    post_params = if params.is_a?(String)
      { 'sound[url]' => params }
    else
      sound_params = {
        'sound[url]' => params[:url],
        'sound[list_id]' => params[:list_id]
      }
      if params[:attribution]
        attribution_params = { 
          'attribution[media_entity]'           => params[:attribution][:media_entity],
          'attribution[author]'                 => params[:attribution][:media_entity],
          'attribution[author_url]'             => params[:attribution][:media_entity],
          'attribution[attribution_license_id]' => params[:attribution][:media_entity]
        }
        sound_params.merge(attribution_params)
      else
        sound_params
      end
    end
    Iknow::RestClient::Item.add_sound(iknow_auth, post_params.merge(:id => self.id))
  end

  def add_tags(iknow_auth, *tags)
    post_params = {}
    tags.each_with_index do |tag, idx|
      if tag.is_a?(String)
        post_params["semantic_tags[#{idx}][name]"] = tag
      else
        post_params["semantic_tags[#{idx}][name]"] = tag[:name]
        post_params["semantic_tags[#{idx}][disambiguation]"] = tag[:disambiguation]
      end
    end
    Iknow::RestClient::Item.add_tags(iknow_auth, post_params.merge(:id => self.id))
  end

  protected

  def to_post_data
    self.validate
    post_data = {
      'cue[text]'           => self.cue.text,
      'cue[language]'       => self.cue.language,
      'cue[part_of_speech]' => self.cue.part_of_speech,
      'response[text]'      => self.response.text,
      'response[language]'  => self.response.language
    }
    # Optional attributes
    if self.list
      post_data['item[list_id]'] = self.list.id
    end
    if response.text_with_character
      post_data['character_response[text]'] = self.response.character_text
    end
    post_data
  end

  def validate
    raise ArgumentError.new("Item cue[text] is required.") if self.cue.text.nil? or self.cue.text.empty?
    raise ArgumentError.new("Item cue[language] is required.") if self.cue.language.nil? or self.cue.language.empty?
    raise ArgumentError.new("Item cue[part_of_speech] is required.") if self.cue.part_of_speech.nil? or self.cue.part_of_speech.empty?
    raise ArgumentError.new("Item response[text] is required.") if self.response.text.nil? or self.response.text.empty?
    raise ArgumentError.new("Item response[language] is required.") if self.response.language.nil? or self.response.language.empty?
  end

  def response
    self.responses.first
  end

end