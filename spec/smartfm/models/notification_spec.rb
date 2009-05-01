require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

matake_notifications = Smartfm::User.find('matake').notifications

Smartfm::Notification::ATTRIBUTES.each do |attr|
  describe Smartfm::Notification, "##{attr}" do
    it "should be accessible" do
      matake_notifications.first.should respond_to(attr)
    end
  end
end