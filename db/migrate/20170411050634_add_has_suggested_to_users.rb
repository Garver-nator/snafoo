class AddHasSuggestedToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :has_suggested, :boolean, :default => false
  end
end
