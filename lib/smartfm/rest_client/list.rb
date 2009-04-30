class Smartfm::RestClient::List < Smartfm::RestClient::Base
  
  ACTIONS = {
    :recent      => {:path => '/lists'                     },
    :find        => {:path => '/lists/__id__'              },
    :items       => {:path => '/lists/__id__/items'        },
    :sentences   => {:path => '/lists/__id__/sentences'    },
    :matching    => {:path => '/lists/matching/__keyword__'},
    :likes       => {:path => '/lists/__id__/likes'        },
    :create      => {:path => '/lists',                          :http_method => :post},
    :add_item    => {:path => '/lists/__id__/items',             :http_method => :post},
    :like!       => {:path => '/lists/__id__/likes',             :http_method => :post},
    :delete      => {:path => '/lists/__id__',                   :http_method => :delete},
    :delete_item => {:path => '/lists/__id__/items/__item_id__', :http_method => :delete},
    :unlike!     => {:path => '/lists/__id__/likes',             :http_method => :delete}
  }

end