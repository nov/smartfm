class Smartfm::RestClient::User < Smartfm::RestClient::Base

  ACTIONS = {
    :current              => {:path => '/users'                           },
    :find                 => {:path => '/users/__username__'              },
    :lists                => {:path => '/users/__username__/lists'        },
    :items                => {:path => '/users/__username__/items'        },
    :friends              => {:path => '/users/__username__/friends'      },
    :followers            => {:path => '/users/__username__/followers'    },
    :friends_of_current   => {:path => '/friends'                         },
    :followers_of_current => {:path => '/followers'                       },
    :likes                => {:path => '/users/__username__/likes'        },
    :notifications        => {:path => '/users/__username__/notifications'},
    :matching             => {:path => '/users/matching/__keyword__'      },
    :study_results        => {:path => '/users/__username__/study_results/__application__'},
    :follow!              => {:path => '/users/__username__/friends', :http_method => :post},
    :unfollow!            => {:path => '/users/__username__/friends', :http_method => :delete}
  }

end