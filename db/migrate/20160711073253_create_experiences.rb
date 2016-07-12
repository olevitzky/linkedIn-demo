class CreateExperiences < ActiveRecord::Migration
  def change
    create_table :experiences do |t|
      t.integer :profile_id
      t.string :company
      t.string :title
      t.date :start_date
      t.date :end_date
      t.timestamps null: false
    end
  end
end
