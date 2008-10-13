class Iknow::User < Iknow::Base
  attr_reader :username, :profile
  
  class Profile
    attr_reader :name, :gender, :birthday, :description,
                :blog_url, :profile_url, :foaf_url, :icon_url
    def initialize(params = {})
      @name        = params['name']
      @gender      = params['gender']
      @birthday    = (Date.parse(params['birthday']) rescue nil)
      @description = params['description']
      @blog_url    = params['blog_url']
      @profile_url = params['profile_url']
      @foaf_url    = params['foaf_url']
      @icon_url    = params['icon_url']
    end
  end
  
  class StudyResult
    attr_reader :timestamp, :seconds, :totals, :seen, :completed, :date

    def initialize(params = {})
      @timestamp = (params['timestamp'].to_i   rescue nil)
      @seconds   = (params['seconds'].to_i     rescue nil)
      @totals    = {
        :seconds   => (params['totals']['seconds'].to_i   rescue nil),
        :seen      => (params['totals']['seen'].to_i      rescue nil),
        :completed => (params['totals']['completed'].to_i rescue nil)
      }
      @seen      = (params['seen'].to_i        rescue nil)
      @completed = (params['completed'].to_i   rescue nil)
      @date      = (Date.parse(params['date']) rescue nil)
    end
  end
  
  def self.find(username)
    response = Iknow::RestClient::User.show(:username => username)
    self.new(response)
  end
  
  def self.matching(keyword, params = {})
    params[:keyword] = keyword
    responses = Iknow::RestClient::User.matching(params)
    users = []
    responses.each do |response|
      users << Iknow::User.new(response)
    end
    users
  end
  
  def initialize(params)
    @profile  = Profile.new(params['profile'])
    @username = params['username']
    @study_results, @items, @lists = [], [], []
  end
  
  def items(params = {})
    return @items unless @items.empty?
    
    responses = Iknow::RestClient::User.items(params.merge(:username => self.username))
    responses.each do |item|
      @items << Iknow::Item.new(item)
    end
    @items
  end
  
  def lists(params = {})
    return @lists unless @lists.empty?
    
    responses = Iknow::RestClient::User.lists(params.merge(:username => self.username))
    responses.each do |list|
      @lists << Iknow::List.new(list)
    end
    @lists
  end
  
  def study_results(params = {})
    return @study_results unless @study_results.empty?
  
    params[:application] = :iknow
    response = Iknow::RestClient::User.study_results(params.merge(:username => self.username))
    response['study_results'].each do |study_result|
      @study_results << StudyResult.new(study_result)
    end
    @study_results.sort! {|a, b| a.timestamp <=> b.timestamp}
  end
  
  def method_missing(method, *args)
    if profile.respond_to? method
      profile.send(method)
    else
      super
    end
  end
  
end