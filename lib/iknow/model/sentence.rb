class Iknow::Sentence < Iknow::Base
  ATTRIBUTES = [:sound, :image, :text]
  WRITABLE_ATTRIBUTES = [:sound, :image]
  attr_accessor *WRITABLE_ATTRIBUTES
  attr_reader *(ATTRIBUTES - WRITABLE_ATTRIBUTES)

  def self.recent(params = {})
    response = Iknow::RestClient::Sentence.recent(params)
    self.deserialize(response) || []
  end

  def self.matching(keyword, params = {})
    params[:keyword] = keyword
    response = Iknow::RestClient::Sentence.matching(params)
    self.deserialize(response) || []
  end

  def initialize(params = {})
    @sound = params['sound']
    @image = params['image']
    @text  = params['text']
  end

end