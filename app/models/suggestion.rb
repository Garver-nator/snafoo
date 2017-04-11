class Suggestion < ApplicationRecord
    validates :name, uniqueness: {message: "Duplicate Suggestion"}
    validates_presence_of :name
    
    def voted
        new_total = self.votes + 1
        return self.update(votes: new_total)
    end
    
    def self.suggestions
        return Suggestion.all.select(:name).map(&:name).sort
    end
    
end
    