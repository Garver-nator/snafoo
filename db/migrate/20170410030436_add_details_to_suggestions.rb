class AddDetailsToSuggestions < ActiveRecord::Migration[5.0]
  def change
    add_column :suggestions, :name, :string
    add_column :suggestions, :votes, :integer, :default => 0
  end
end
