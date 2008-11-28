class Iknow::User < Iknow::Base
  ATTRIBUTES = [:username, :profile]
  attr_reader *ATTRIBUTES

  class Profile < Iknow::Base
    ATTRIBUTES = [:name, :gender, :birthday, :description, :blog_url, :profile_url, :foaf_url, :icon_url]
    attr_reader *ATTRIBUTES

    def initialize(params = {})
      @name        = params[:name]
      @gender      = params[:gender]
      @birthday    = (Date.parse(params[:birthday]) rescue nil)
      @description = params[:description]
      @blog_url    = params[:blog_url]
      @profile_url = params[:profile_url]
      @foaf_url    = params[:foaf_url]
      @icon_url    = params[:icon_url]
    end
  end

  class Study < Iknow::Base
    ATTRIBUTES = [:today, :results, :total_summary]
    attr_reader *ATTRIBUTES

    class Result < Iknow::Base
      ATTRIBUTES = [:timestamp, :seconds, :totals, :seen, :completed, :date]
      attr_reader *ATTRIBUTES

      def initialize(params = {})
        @timestamp = (params[:timestamp].to_i   rescue nil)
        @seconds   = (params[:seconds].to_i     rescue nil)
        @totals    = {
          :seconds   => (params[:totals][:seconds].to_i   rescue nil),
          :seen      => (params[:totals][:seen].to_i      rescue nil),
          :completed => (params[:totals][:completed].to_i rescue nil)
        }
        @seen      = (params[:seen].to_i        rescue nil)
        @completed = (params[:completed].to_i   rescue nil)
        @date      = (Date.parse(params[:date]) rescue nil)
      end
    end

    class TotalSummary < Iknow::Base
      ATTRIBUTES = [:studied, :completed, :performance, :best_speed, :best_score]
      attr_reader *ATTRIBUTES

      def initialize(params = {})
        @studied     = params[:studied]
        @completed   = params[:completed]
        @performance = params[:performance]
        @best_speed  = params[:best_speed]
        @best_score  = params[:best_score]
      end
    end

    def initialize(params = {})
      @today         = (Date.parse(params[:today]) rescue nil)
      @results       = self.deserialize(params[:study_results], :as => Iknow::User::Study::Result)
      @total_summary = self.deserialize(params[:total_summary], :as => Iknow::User::Study::TotalSummary)
    end

  end

  def self.find(username, params = {})
    params[:username] = username
    response = Iknow::RestClient::User.find(params)
    self.deserialize(response)
  end

  def self.matching(keyword, params = {})
    params[:keyword] = keyword
    response = Iknow::RestClient::User.matching(params)
    self.deserialize(response) || []
  end

  def initialize(params)
    @profile  = Profile.new(params[:profile])
    @username = params[:username]
  end

  def items(params = {})
    response = Iknow::RestClient::User.items(params.merge(:username => self.username))
    self.deserialize(response, :as => Iknow::Item) || []
  end

  def lists(params = {})
    response = Iknow::RestClient::User.lists(params.merge(:username => self.username))
    self.deserialize(response, :as => Iknow::List) || []
  end

  def friends(params = {})
    response = Iknow::RestClient::User.friends(params.merge(:username => self.username))
    self.deserialize(response) || []
  end

  def study(params = {})
    params[:application] ||= 'iknow'
    response = Iknow::RestClient::User.study_results(params.merge(:username => self.username))
    self.deserialize(response, :as => Iknow::User::Study)
  end

end