class User < ApplicationRecord
    validates_presence_of :remaining_votes
    
    def self.establish_user(id)
        id ? id : User.create().id
    end
           
    # Decrement's the user's remaining votes, or returns false if they are out of votes 
    def vote
        if self.remaining_votes <= 0
            return false
        else
            votes = self.remaining_votes
            return self.update(remaining_votes: votes - 1)
        end
    end
    
    # Toggles the has_suggested boolean
    def suggest
        if self.has_suggested
            return false
        else
            return self.update(has_suggested: true)
        end
    end
    
    def can_vote?
        return self.remaining_votes > 0
    end
    
    def can_suggest?
        return !self.has_suggested
    end
end 