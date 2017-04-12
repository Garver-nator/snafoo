FactoryGirl.define do
    factory :user do 
        remaining_votes 3
        has_suggested false
    end
end