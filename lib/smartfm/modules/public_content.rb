module Smartfm::PublicContent

  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end

  module ClassMethods
    def recent(params = {})
      hash = self.rest_client.recent(params)
      self.deserialize(hash) || []
    end

    def find(list_id, params = {})
      params[:id] = list_id
      hash = self.rest_client.find(params)
      self.deserialize(hash)
    end

    def matching(keyword, params = {})
      params[:keyword] = keyword
      hash = self.rest_client.matching(params)
      self.deserialize(hash) || []
    end

    def create(auth, params = {})
      self.new(params).save(auth)
    end

    def delete(obj_id)
      self.find(obj_id).delete
    end
  end

  module InstanceMethods
    def save(auth)
      result = self.rest_client.create(auth, self.to_post_data)
      case result
      when Hash
        self.deserialize(result)
      when String
        self.find(result)
      else
        true
      end
    end

    def delete(auth)
      self.rest_client.delete(auth, {:id => self.id})
    end
    alias_method :destroy, :delete
  end

end