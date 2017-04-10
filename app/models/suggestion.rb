class Suggestion < ApplicationRecord
    validates :name, uniqueness: {message: "Duplicate Suggestion"}
    validates_presence_of :name
    
    def self.vote(snack)
        suggestion = Suggestion.find_by(name: snack)
        new_total = suggestion.votes + 1
        suggestion.update(votes: new_total)
    end
    
    def self.suggestions
        return Suggestion.all.select(:name).map(&:name).sort
    end
    
end
    