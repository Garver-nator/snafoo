FactoryGirl.define do
    factory :suggestion do
        name                    "Chips"
        last_purchase_date      "3/1/2017"
    end
    
    factory :invalid_suggestion, parent: :suggestion do
        name                    nil
    end
end