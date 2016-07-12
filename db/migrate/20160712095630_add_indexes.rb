class AddIndexes < ActiveRecord::Migration
  def change
    add_index :profiles, :full_name
    add_index :profiles, :title
    add_index :profiles, :current_position
    add_index :profiles, :summary
    add_index :profiles, :skills
    add_index :profiles, :uuid
  end
end
