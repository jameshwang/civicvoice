class CreateUserPetitions < ActiveRecord::Migration
  def change
    create_table :user_petitions do |t|
      t.integer :user_id
      t.integer :petition_id

      t.timestamps
    end
  end
end
