class Smartfm::RestClient::Sentence < Smartfm::RestClient::Base
  
  ACTIONS = {
    :recent    => {:path => '/sentences'                     },
    :find      => {:path => '/sentences/__id__'              },
    :matching  => {:path => '/sentences/matching/__keyword__'},
    :create    => {:path => '/sentences',               :http_method => :post},
    :add_image => {:path => '/sentences/__id__/images', :http_method => :post},
    :add_sound => {:path => '/sentences/__id__/sounds', :http_method => :post},
    :like!     => {:path => '/sentences/__id__/likes',  :http_method => :post},
    :unlike!   => {:path => '/sentences/__id__/likes',  :http_method => :delete}
  }
  
end