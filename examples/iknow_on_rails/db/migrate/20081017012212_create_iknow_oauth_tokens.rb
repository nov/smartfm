class CreateIknowOauthTokens < ActiveRecord::Migration
  def self.up
    create_table :iknow_oauth_tokens do |t|
      t.column :iknow_username, :string, :null => false
      t.column :token,          :string, :unique => true
      t.column :secret,         :string
    end
    add_index :iknow_oauth_tokens, :token, :unique => true
    add_index :iknow_oauth_tokens, :iknow_username
  end
  
  def self.down
    drop_table :iknow_oauth_tokens
  end
end