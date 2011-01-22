class User < ActiveRecord::Base
  has_many :accounts, :foreign_key => 'owner_id'
end
