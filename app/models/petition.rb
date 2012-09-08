class Petition < ActiveRecord::Base
  attr_accessible :description, :name, :pdf_link
  has_many :user_petitions
  has_many :users, :through => :user_petitions
end
