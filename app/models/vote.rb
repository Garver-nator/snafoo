class Vote < ApplicationRecord
    validates_presence_of :user_id
    validates_presence_of :suggestion_id
    
    def self.has_voted?(user_id, suggestion_id)
        return !(Vote.find_by(user_id: user_id, suggestion_id: suggestion_id).nil?)
    end
end