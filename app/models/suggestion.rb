class Suggestion < ApplicationRecord
    validates_presence_of :name
    validates :name, uniqueness: {message: "Duplicate Suggestion"}
    
    def voted
        new_total = self.votes + 1
        return self.update(votes: new_total)
    end
    
    def self.suggestions
        return Suggestion.all.select(:name).map(&:name).sort
    end
end
    