class User < ActiveRecord::Base
  attr_accessible :email, :name, :username
  has_many :user_petitions
  has_many :petitions, :through => :user_petitions
end
