class Iknow::RestClient::User < Iknow::RestClient::Base
  
  ACTIONS = {
    :show          => { :path => '/users/__username__'         },
    :study_results => { :path => '/users/__username__/study_results/__application__'   },
    :lists         => { :path => '/users/__username__/lists'   },
    :items         => { :path => '/users/__username__/items'   },
    :matching      => { :path => '/users/matching/__keyword__' }
  }
  
end