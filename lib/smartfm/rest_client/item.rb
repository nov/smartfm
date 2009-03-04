class Smartfm::RestClient::Item < Smartfm::RestClient::Base

  ACTIONS = {
    :recent    => { :path => '/items'                      },
    :find      => { :path => '/items/__id__'               },
    :matching  => { :path => '/items/matching/__keyword__' },
    :extract   => { :path => '/items/extract',             },
    :create    => { :path => '/items',               :http_method => :post },
    :add_image => { :path => '/items/__id__/images', :http_method => :post },
    :add_sound => { :path => '/items/__id__/sounds', :http_method => :post },
    :add_tags  => { :path => '/items/__id__/tags',   :http_method => :post }
  }

end