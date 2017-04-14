class Suggestion < ApplicationRecord
    validates_presence_of :name
    validates :name, uniqueness: {message: "Duplicate Suggestion"}
    
    # Increments suggestion's vote count
    def voted
        new_total = self.votes + 1
        return self.update(votes: new_total)
    end
    
    # Returns an array of Suggestion hashes in alphabetical order
    def self.suggestions
        return Suggestion.order(:name).all.collect{ |s| {:name => s.name, :last_purchase_date => s.last_purchase_date, :votes => s.votes} }
    end 
    
    # Returns true iff the given hash fits all criteria for a valid Suggestion
    def self.is_valid?(suggestion)
        return (!suggestion.nil?) && (suggestion[:name] != "") && (!suggestion[:name].nil?) && (Suggestion.find_by(name: suggestion[:name]).nil?) && (suggestion["name"].length <= 200) && (suggestion["name"].length >= 0)
    end
end
    