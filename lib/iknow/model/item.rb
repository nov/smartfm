class Iknow::Item < Iknow::Base
  ATTRIBUTES = [:sentences, :hash, :cue, :id]
  attr_reader *ATTRIBUTES

  class Response
    ATTRIBUTES = [:text, :type, :language]
    attr_reader *ATTRIBUTES
    
    def initialize(params = {})
      @text     = params[:text]
      @type     = params[:type]
      @language = params[:language]
    end
  end

  class Cue
    ATTRIBUTES = [:text, :sound, :part_of_speech, :language]
    NOT_WRITABLE_ATTRIBUTES = [:text]
    attr_accessor *(ATTRIBUTES - NOT_WRITABLE_ATTRIBUTES)
    attr_reader *NOT_WRITABLE_ATTRIBUTES
    
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

  def initialize(params = {})
    @id        = params[:id].to_i
    @cue       = self.deserialize(params[:cue], :as => Iknow::Item::Cue)
    @hashs = self.deserialize(params[:hashs], :as => Iknow::Item::Response)
    @sentences = self.deserialize(params[:sentences], :as => Iknow::Sentence)
  end

end