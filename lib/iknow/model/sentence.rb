class Iknow::Sentence < Iknow::Base
  ATTRIBUTES = [:sound, :image, :text, :language, :id, :transliterations, :translations]
  WRITABLE_ATTRIBUTES = [:sound, :image]
  attr_accessor *WRITABLE_ATTRIBUTES
  attr_reader *(ATTRIBUTES - WRITABLE_ATTRIBUTES)

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

  def initialize(params = {})
    @id       = params[:id]
    @sound    = params[:sound]
    @image    = params[:image]
    @text     = params[:text]
    @language = params[:language]
    @transliterations = params[:transliterations]
    @translations = self.deserialize(params[:translations], :as => Iknow::Sentence)
  end

end