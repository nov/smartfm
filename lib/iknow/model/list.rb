class Iknow::List < Iknow::Base
  attr_accessor :title, :description, :link,
                :language, :translation_language, :list_type, :transcript, :embed,
                :tags, :media_entry, :author, :author_url, :attribution_license_id
  attr_reader   :list_id

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

  def self.create(auth_token, params = {})
    self.new(params).set_auth_token(auth_token).save!
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

  def save!
    Iknow::RestClient::List.create(@auth_token, self)
  end

  def save
    self.save!
    true
  rescue
    false
  end

end