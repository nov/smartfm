class Smartfm::Item < Smartfm::Base
  ATTRIBUTES = [:sentences, :responses, :cue, :id, :list, :user]
  READONLY_ATTRIBUTES = [:sentences, :responses, :cue, :id, :user]
  attr_accessor *(ATTRIBUTES - READONLY_ATTRIBUTES)
  attr_reader *READONLY_ATTRIBUTES

  include Smartfm::PublicContent
  include Smartfm::MediaSupport
  include Smartfm::ActsAsLikable

  def self.rest_client; Smartfm::RestClient::Item; end
  def rest_client; self.class.rest_client; end

  class Response < Smartfm::Base
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

  class Cue < Smartfm::Base
    ATTRIBUTES = [:type, :text, :image, :sound, :part_of_speech, :language, :transliterations]
    READONLY_ATTRIBUTES = [:sound]
    attr_accessor *(ATTRIBUTES - READONLY_ATTRIBUTES)
    attr_reader *READONLY_ATTRIBUTES

    def initialize(params = {})
      @type             = params[:type]
      @text             = params[:text]
      @image            = params[:image]
      @sound            = params[:sound]
      @part_of_speech   = params[:part_of_speech]
      @language         = params[:language]
      @transliterations = params[:transliterations]
    end
  end

  def initialize(params = {})
    params[:responses] = Array(params[:response]) if params[:response]
    @id        = params[:id].to_i if params[:id]
    @list      = params[:list]
    @cue       = self.deserialize(params[:cue],       :as => Smartfm::Item::Cue)
    @responses = self.deserialize(params[:responses], :as => Smartfm::Item::Response)
    @sentences = self.deserialize(params[:sentences], :as => Smartfm::Sentence)
    @user      = self.deserialize(params[:user],      :as => Smartfm::User)
  end

  def self.extract(text, params = {})
    params[:text] = text
    hash = self.rest_client.extract(params)
    if params[:words_only] == false
      self.deserialize(hash) || []
    else
      hash
    end
  end

  def add_tags(auth, *tags)
    post_params = {}
    tags.each_with_index do |tag, idx|
      if tag.is_a?(String)
        post_params["semantic_tags[#{idx}][name]"] = tag
      else
        post_params["semantic_tags[#{idx}][name]"] = tag[:name]
        post_params["semantic_tags[#{idx}][disambiguation]"] = tag[:disambiguation]
      end
    end
    self.rest_client.add_tags(auth, post_params.merge(:id => self.id))
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