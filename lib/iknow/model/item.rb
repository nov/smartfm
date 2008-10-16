class Iknow::Item < Iknow::Base
  ATTRIBUTES = [:sentences, :response, :cue, :id]
  attr_reader *ATTRIBUTES

  class Response
    ATTRIBUTES = [:text]
    attr_reader *ATTRIBUTES
    
    def initialize(params = {})
      @text = params['text']
    end
  end

  class Cue
    ATTRIBUTES = [:sound, :part_of_speech, :text]
    NOT_WRITABLE_ATTRIBUTES = [:text]
    attr_accessor *(ATTRIBUTES - NOT_WRITABLE_ATTRIBUTES)
    attr_reader *NOT_WRITABLE_ATTRIBUTES
    
    def initialize(params = {})
      @text  = params['text']
      @sound = params['sound']
      @image = params['part_of_speech']
    end
  end

  def self.recent(params = {})
    response = Iknow::RestClient::Item.recent(params)
    self.deserialize(response)
  end

  def self.matching(keyword, params = {})
    params[:keyword] = keyword
    response = Iknow::RestClient::Item.matching(params)
    self.deserialize(response)
  end

  def self.extract(text, params = {})
    params[:text] = text
    response = Iknow::RestClient::Item.extract(params)
    self.deserialize(response)
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