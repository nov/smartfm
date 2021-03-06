module Smartfm::PrivateContent

  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end

  module ClassMethods
    def of_current(auth, params = {})
      hash = self.rest_client.of_current(auth, params)
      self.deserialize(hash) || []
    end

    def create(auth, params = {})
      self.new(params).save(auth)
    end
  end

  module InstanceMethods
    def save(auth)
      self.rest_client.create(auth, self.to_post_data)
    end
  end

end