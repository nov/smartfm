module Smartfm::MediaSupport

  def attribution_params(attr_params)
    return {} unless attr_params
    {
      'attribution[medias_entity]'           => attr_params[:media_entity],
      'attribution[author]'                  => attr_params[:author],
      'attribution[author_url]'              => attr_params[:author_url],
      'attributions[attribution_license_id]' => attr_params[:attribution_license_id]
    }
  end

  def add_image(auth, params)
    post_params = if params.is_a?(String)
      {'image[url]' => params}
    else
      {
        'image[url]' => params[:url],
        'image[list_id]' => params[:list_id]
      }.merge(attribution_params(params[:attribution]))
    end
    self.rest_client.add_image(auth, post_params.merge(:id => self.id))
  end

  def add_sound(auth, params)
    post_params = if params.is_a?(String)
      {'sound[url]' => params}
    else
      {
        'sound[url]' => params[:url],
        'sound[list_id]' => params[:list_id]
      }.merge(attribution_params(params[:attribution]))
    end
    self.rest_client.add_sound(auth, post_params.merge(:id => self.id))
  end

end