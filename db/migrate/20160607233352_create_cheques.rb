class CreateCheques < ActiveRecord::Migration
  def change
    create_table :cheques do |t|
      t.string :name
      t.date :creation
      t.integer :value

      t.timestamps null: false
    end
  end
end
