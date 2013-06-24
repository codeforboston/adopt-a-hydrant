class AddTokenAndExpiryFieldsToUser < ActiveRecord::Migration
  def change
  	add_column	:users, :provider_secret, :string
  	add_column	:users, :provider_token, :string
  	add_column	:users, :provider_token_expire, :integer
  	add_index :users, [:provider_token, :provider_token_expire]
  end
end
