class CreatePetitions < ActiveRecord::Migration
  def change
    create_table :petitions do |t|
      t.string :name
      t.text :description, :limit => nil
      t.string :pdf_link

      t.timestamps
    end
  end
end
