class Suggestion < ApplicationRecord
    validates_presence_of :name
    validates :name, uniqueness: {message: "Duplicate Suggestion"}
    
    def voted
        new_total = self.votes + 1
        return self.update(votes: new_total)
    end
    
    def self.suggestions
        return Suggestion.order(:name).all.collect{ |s| {:name => s.name, :last_purchase_date => s.last_purchase_date, :votes => s.votes} }
    end 
    
    def self.is_valid?(suggestion)
        return (!suggestion.nil?) && (suggestion[:name] != "") && (!suggestion[:name].nil?) && (Suggestion.find_by(name: suggestion[:name]).nil?) && (suggestion["name"].length <= 200) && (suggestion["name"].length >= 0)
    end
end
    