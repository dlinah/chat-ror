class App < ApplicationRecord
  has_secure_token
  has_many :chats 
end
