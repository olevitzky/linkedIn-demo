class AddStateToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :state, :string
  end
end
