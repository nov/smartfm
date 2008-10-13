class Iknow::Item
  attr_reader :sentences, :response, :cue, :id
  
  class Response
    attr_reader :text
    def initialize(params = {})
      @text = params['text']
    end
  end
  
  class Cue
    attr_accessor :sound, :part_of_speech
    attr_reader :text
    def initialize(params = {})
      @text  = params['text']
      @sound = params['sound']
      @image = params['part_of_speech']
    end
  end
  
  def self.recent(params = {})
    responses = Iknow::RestClient::Item.recent(params)
    items = []
    responses.each do |response|
      items << Iknow::Item.new(response)
    end
    items
  end
  
  def self.matching(keyword, params = {})
    params[:keyword] = keyword
    responses = Iknow::RestClient::Item.matching(params)
    items = []
    responses.each do |response|
      items << Iknow::Item.new(response)
    end
    items
  end
  
  def initialize(params = {})
    @id = params['id'].to_i
    @sentences = []
    params['sentences'].each do |sentence|
      @sentences << Iknow::Sentence.new(sentence)
    end
    @response = params['response'] ? Iknow::Item::Response.new(params['response']) : nil
    @cue      = Iknow::Item::Cue.new(params['cue'])
  end
  
end