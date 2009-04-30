class Smartfm::RestClient::Notification < Smartfm::RestClient::Base

  ACTIONS = {
    :of_current => {:path => '/notifications'},
    :create     => {:path => '/notifications', :http_method => :post},
  }

end