class CreatePetitions < ActiveRecord::Migration
  def change
    create_table :petitions do |t|
      t.text :name
      t.text :description
      t.string :pdf_link

      t.timestamps
    end
  end
end
