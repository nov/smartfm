class Smartfm::RestClient::User < Smartfm::RestClient::Base

  ACTIONS = {
    :find          => { :path => '/users/__username__'           },
    :lists         => { :path => '/users/__username__/lists'     },
    :items         => { :path => '/users/__username__/items'     },
    :friends       => { :path => '/users/__username__/friends'   },
    :followers     => { :path => '/users/__username__/followers' },
    :study_results => { :path => '/users/__username__/study_results/__application__'   },
    :matching      => { :path => '/users/matching/__keyword__'   }
  }

end