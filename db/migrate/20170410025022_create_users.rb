class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.integer :remaining_votes, :default => 3
    end
  end
end
