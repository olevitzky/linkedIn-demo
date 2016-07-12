class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :uuid
      t.string :first_name
      t.string :last_name
      t.string :full_name
      t.string :title
      t.string :current_position
      t.text :summary
      t.text :skills, array: true, default: []
      t.float :score, default: 0
      t.timestamps null: false
    end
  end
end
