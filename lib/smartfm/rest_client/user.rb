class Smartfm::RestClient::User < Smartfm::RestClient::Base

  ACTIONS = {
    :find          => {:path => '/users/__username__'          },
    :lists         => {:path => '/users/__username__/lists'    },
    :items         => {:path => '/users/__username__/items'    },
    :friends       => {:path => '/users/__username__/friends'  },
    :followers     => {:path => '/users/__username__/followers'},
    :likes         => {:path => '/users/__username__/likes'    },
    :study_results => {:path => '/users/__username__/study_results/__application__'},
    :matching      => {:path => '/users/matching/__keyword__'  },
    :logging_in    => {:path => '/users'                       },
    :follow!       => {:path => '/users/__username__/friends', :http_method => :post},
    :unfollow!     => {:path => '/users/__username__/friends', :http_method => :delete}
 }

end