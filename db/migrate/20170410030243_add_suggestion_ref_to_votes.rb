class AddSuggestionRefToVotes < ActiveRecord::Migration[5.0]
  def change
    add_reference :votes, :suggestion, foreign_key: true
  end
end
