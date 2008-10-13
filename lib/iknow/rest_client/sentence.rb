class Iknow::RestClient::Sentence < Iknow::RestClient::Base
  
  ACTIONS = {
    :recent    => { :path => '/sentences'                                      },
    :matching  => { :path => '/sentences/matching/__keyword__'                 },
    :create    => { :path => '/sentences',               :http_method => :post },
    :add_image => { :path => '/sentences/__id__/images', :http_method => :post },
    :add_sound => { :path => '/sentences/__id__/sounds', :http_method => :post }
  }
  
end