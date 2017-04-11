class AddLastPurchaseDateToSuggestions < ActiveRecord::Migration[5.0]
  def change
    add_column :suggestions, :last_purchase_date, :string
  end
end
