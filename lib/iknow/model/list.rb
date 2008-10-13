class Iknow::List < Iknow::Base
  attr_accessor :title, :description, :link
  attr_reader :list_id
  
  # def self.find(id, params = {})
  #   items_response     = Iknow::RestClient::List.items(params.merge(:id => id))
  #   sentences_response = Iknow::RestClient::List.sentences(params.merge(:id => id))
  #   items_response.each do |item|
  #     @items << Iknow::Item.new(item)
  #   end
  #   sentences_response.each do |sentence|
  #     @sentences << Iknow::Sentence.new(sentence)
  #   end
  # end

  def self.recent(params = {})
    responses = Iknow::RestClient::List.recent(params)
    lists = []
    responses.each do |response|
      lists << Iknow::List.new(response)
    end
    lists
  end
  
  def self.matching(keyword, params = {})
    params[:keyword] = keyword
    responses = Iknow::RestClient::List.matching(params)
    lists = []
    responses.each do |response|
      lists << Iknow::List.new(response)
    end
    lists
  end
  
  def initialize(params = {})
    @list_id     = params['id'].to_i if params['id']
    @title       = params[:title] || params['title']
    @description = params[:description] || params['description']
    @link        = params[:link] || params['link']
    @items, @sentences = [], []
  end
    
  
  def items(params = {})
    return @items unless @items.empty?
    
    responses = Iknow::RestClient::List.items(params.merge(:id => self.list_id))
    responses.each do |item|
      @items << Iknow::Item.new(item)
    end
  end
  
  def sentences(params = {})
    return @sentences unless @sentences.empty?
    
    responses = Iknow::RestClient::List.sentences(params.merge(:id => self.list_id))
    responses.each do |sentence|
      @sentences << Iknow::Sentence.new(sentence)
    end
  end
  
end