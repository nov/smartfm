class Iknow::Sentence < Iknow::Base
  attr_accessor :sound, :image
  attr_reader :text
  
  def self.recent(params = {})
    responses = Iknow::RestClient::Sentence.recent(params)
    sentences = []
    responses.each do |response|
      sentences << Iknow::Sentence.new(response)
    end
    sentences
  end
  
  def self.matching(keyword, params = {})
    params[:keyword] = keyword
    responses = Iknow::RestClient::Sentence.matching(params)
    sentences = []
    responses.each do |response|
      sentences << Iknow::Sentence.new(response)
    end
    sentences
  end
  
  def initialize(params = {})
    @sound = params['sound']
    @image = params['image']
    @text  = params['text']
  end
  
end