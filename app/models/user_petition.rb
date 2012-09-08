class UserPetition < ActiveRecord::Base
  attr_accessible :petition_id, :user_id

  belongs_to :user
  belongs_to :petition
end
