class Vote < ApplicationRecord
    
    def self.has_voted?(user_id, suggestion_id)
        return !(Vote.find_by(user_id: user_id, suggestion_id: suggestion_id).nil?)
    end
end