class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.integer :profile_id
      t.string :name
      t.integer :first_year
      t.integer :final_year
      t.timestamps null: false
    end
  end
end
