class CreatePetitions < ActiveRecord::Migration
  def change
    create_table :petitions do |t|
      t.string :name
      t.string :description
      t.string :pdf_link

      t.timestamps
    end
  end
end
