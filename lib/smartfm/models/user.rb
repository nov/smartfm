class Smartfm::User < Smartfm::Base
  ATTRIBUTES = [:username, :profile]
  attr_reader *ATTRIBUTES

  def self.rest_client; Smartfm::RestClient::User; end
  def rest_client; self.class.rest_client; end

  class Profile < Smartfm::Base
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

  class Study < Smartfm::Base
    ATTRIBUTES = [:today, :results, :total_summary]
    attr_reader *ATTRIBUTES

    class Result < Smartfm::Base
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

    class TotalSummary < Smartfm::Base
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
      @results       = self.deserialize(params[:study_results], :as => Smartfm::User::Study::Result)
      @total_summary = self.deserialize(params[:total_summary], :as => Smartfm::User::Study::TotalSummary)
    end
  end

  def initialize(params)
    @profile  = Profile.new(params[:profile])
    @username = params[:username]
  end

  def self.find(username, params = {})
    params[:username] = username
    hash = self.rest_client.find(params)
    self.deserialize(hash)
  end

  def self.matching(keyword, params = {})
    params[:keyword] = keyword
    hash = self.rest_client.matching(params)
    self.deserialize(hash) || []
  end

  def self.current(auth, params = {})
    self.rest_client.current(auth, params)
  end

  def self.friends(auth, params = {})
    self.rest_client.friends_of_current(auth, params)
  end

  def self.followers(auth, params = {})
    self.rest_client.followers_of_current(auth, params)
  end

  def friends(params = {})
    hash = self.rest_client.friends(params.merge(:username => self.username))
    self.deserialize(hash) || []
  end

  def followers(params = {})
    hash = self.rest_client.followers(params.merge(:username => self.username))
    self.deserialize(hash) || []
  end

  def friends_of_current(auth, params = {})
    hash = self.rest_client.friends_of_current(auth, params)
    self.deserialize(hash) || []
  end

  def followers_of_current(auth, params = {})
    hash = self.rest_client.followers_of_current(auth, params)
    self.deserialize(hash) || []
  end

  def follow!(auth, params = {})
    self.rest_client.follow!(auth, params.merge(:username => self.username))
  end

  def unfollow!(auth, params = {})
    self.rest_client.unfollow!(auth, params.merge(:username => self.username))
  end

  def items(params = {})
    hash = self.rest_client.items(params.merge(:username => self.username))
    self.deserialize(hash, :as => Smartfm::Item) || []
  end

  def lists(params = {})
    hash = self.rest_client.lists(params.merge(:username => self.username))
    self.deserialize(hash, :as => Smartfm::List) || []
  end

  def likes(params = {})
    hash = self.rest_client.likes(params.merge(:username => self.username))
    self.deserialize(hash, :as => Smartfm::Like) || []
  end

  def notifications(params = {})
    hash = self.rest_client.notifications(params.merge(:username => self.username))
    self.deserialize(hash, :as => Smartfm::Notification) || []
  end

  def study(params = {})
    params[:application] ||= 'iknow'
    return nil unless ['iknow', 'dictation', 'brainspeed', ].include?(params[:application])
    hash = self.rest_client.study_results(params.merge(:username => self.username))
    self.deserialize(hash, :as => Smartfm::User::Study)
  end

end