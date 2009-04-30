module Smartfm::ActsAsLikable

  def likes(params = {})
    hash = self.rest_client.likes(params.merge(:id => self.id))
    self.deserialize(hash, :as => Smartfm::Like) || []
  end

  def like!(auth, params)
    self.rest_client.like!(auth, params.merge(:id => self.id))
  end

  def unlike!(auth, params)
    self.rest_client.unlike!(auth, params.merge(:id => self.id))
  end

end