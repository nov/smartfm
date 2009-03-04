class Smartfm::RestClient::List < Smartfm::RestClient::Base
  
  ACTIONS = {
    :recent      => { :path => '/lists'                      },
    :find        => { :path => '/lists/__id__'               },
    :items       => { :path => '/lists/__id__/items'         },
    :sentences   => { :path => '/lists/__id__/sentences'     },
    :matching    => { :path => '/lists/matching/__keyword__' },
    :create      => { :path => '/lists',                          :http_method => :post   },
    :delete      => { :path => '/lists/__id__',                   :http_method => :delete },
    :add_item    => { :path => '/lists/__list_id__/items',        :http_method => :post   },
    :delete_item => { :path => '/lists/__list_id__/items/__id__', :http_method => :delete }
  }

end