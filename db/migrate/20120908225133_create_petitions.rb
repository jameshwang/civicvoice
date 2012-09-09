class CreatePetitions < ActiveRecord::Migration
  def change
    create_table :petitions do |t|
      t.text :name, :limit => nil
      t.text :description, :limit => nil
      t.string :pdf_link

      t.timestamps
    end
  end
end
