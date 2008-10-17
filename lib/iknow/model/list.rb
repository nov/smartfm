class Iknow::List < Iknow::Base
  ATTRIBUTES = [:list_id, :title, :description, :link,
                :language, :translation_language, :list_type, :transcript, :embed,
                :tags, :media_entry, :author, :author_url, :attribution_license_id]
  NOT_WRITABLE_ATTRIBUTES = [:list_id]
  attr_accessor *(ATTRIBUTES - NOT_WRITABLE_ATTRIBUTES)
  attr_reader   *NOT_WRITABLE_ATTRIBUTES

  def self.recent(params = {})
    response = Iknow::RestClient::List.recent(params)
    self.deserialize(response) || []
  end

  def self.matching(keyword, params = {})
    params[:keyword] = keyword
    response = Iknow::RestClient::List.matching(params)
    self.deserialize(response) || []
  end

  def self.create(params = {})
    new_list = self.new(params)
    new_list.save!
  end

  def initialize(params = {})
    @list_id     = params['id'].to_i if params['id']
    @title       = params[:title]       || params['title']
    @description = params[:description] || params['description']
    @link        = params[:link]        || params['link']
  end

  def items(params = {})
    response = Iknow::RestClient::List.items(params.merge(:id => self.list_id))
    self.deserialize(response, :as => Iknow::Item) || []
  end

  def sentences(params = {})
    response = Iknow::RestClient::List.sentences(params.merge(:id => self.list_id))
    self.deserialize(response, :as => Iknow::Sentence) || []
  end

  def save!
    Iknow::RestClient::List.create(self.to_post_data)
  end

  def save
    self.save!
    true
  rescue
    false
  end

  protected

  def to_post_data
    raise ArgumentError.new("List title is needed.") if self.title.nil? or self.title.empty?
    
    post_data = {
      'list[name]'                 => self.title,
      'list[description]'          => self.description,
      'list[language]'             => self.language             || 'en',
      'list[translation_language]' => self.translation_language || 'ja'
    }
    # Object#type should not be used
    if self.list_type
      post_data['list[type]'] = self.list_type
    end
    # Optional attributes
    [ :transcript, :embed, :tags, :media_entry,
      :author, :author_url, :attribution_license_id ].each do |key|
      if self.send("#{key}")
        post_data["list[#{key}]"] = self.send("#{key}")
      end
    end
    post_data
  end

end