class Iknow::RestClient::List < Iknow::RestClient::Base
  
  ACTIONS = {
    :recent    => { :path => '/lists'                                 },
    :items     => { :path => '/lists/__id__/items'                    },
    :sentences => { :path => '/lists/__id__/sentences'                },
    :matching  => { :path => '/lists/matching/__keyword__'            },
    :create    => { :path => '/lists',        :http_method => :post   },
    :delete    => { :path => '/lists/__id__', :http_method => :delete }
  }

end