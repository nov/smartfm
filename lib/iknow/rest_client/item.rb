class Iknow::RestClient::Item < Iknow::RestClient::Base
  
  ACTIONS = {
    :recent    => { :path => '/items'                                      },
    :find      => { :path => '/items/__id__'                               },
    :matching  => { :path => '/items/matching/__keyword__'                 },
    :add_image => { :path => '/items/__id__/images', :http_method => :post },
    :add_sound => { :path => '/items/__id__/sounds', :http_method => :post },
    :extract   => { :path => '/items/extract',       :http_method => :post }
  }
  
end