class User < ApplicationRecord
    validates_presence_of :remaining_votes
    
end 