require 'rails_helper'

RSpec.describe User, type: :model do
    describe "Create users" do
        it "should create valid users" do
            User.new().should be_valid
        end
    
        it "should allow multiple blank users" do
            User.new().should be_valid
            User.new().should be_valid
        end
        
        it "should be able to differentiate blank users" do 
            a = User.create!()
            b = User.create!()
            
            a.should_not == b
            a.id.should_not == b.id
        end
        
        it "should default to 3 remaining votes" do
            User.new().remaining_votes.should == 3
        end
        
        it "should default has_suggested to false" do
            User.new().has_suggested.should be false
        end
    end
    
    describe "Voting" do
        it "should decrement votes and return true" do
            user1 = User.create!()
            user1.remaining_votes.should == 3
            user1.vote.should be true
            user1.remaining_votes.should == 2
            user1.vote.should be true
            user1.remaining_votes.should == 1
            user1.vote.should be true
            user1.remaining_votes.should == 0
        end
        
        it "should return false if voting with 0 remaining" do
            user1 = User.create!()
            user1.vote
            user1.vote
            user1.vote
            user1.vote.should be false
            user1.remaining_votes.should == 0
        end
        
        it "should return the correct boolean if the user can_vote" do
            user1 = User.create!()
            user1.vote
            user1.can_vote?.should be true
            user1.vote
            user1.can_vote?.should be true
            user1.vote
            user1.can_vote?.should be false
            user1.vote
            user1.can_vote?.should be false
        end
    end
    
    describe "Authentication" do
        it "should create a new user entry if the given id is nil" do
            expect{User.establish_user(nil)}.to change(User, :count).by(1)
        end
        
        it "should find the pre-existing user if the id is valid"  do
            user = User.create!()
            expect{User.establish_user(user.id)}.to_not change(User, :count)
        end
        
        it "should return the id of the found user (or a new key for a new user)" do
            id = User.establish_user(nil)
            db_id = User.first.id
            id.should == db_id
            
            user = User.create!()
            User.establish_user(user.id).should == user.id
            
            User.establish_user(id).should == id
        end
    end
    
    describe "Suggestions" do
        it "should set has_suggested to true if you user.suggest" do
            user = User.create!()
            user.suggest
            user.has_suggested.should == true
        end
        
        it "should return false if the user has already suggested" do
            user = User.create!()
            user.suggest.should be true
            user.suggest.should be false
        end
        
        it "can_suggest? should reflect the right state" do
            user = User.create!()
            user.can_suggest?.should be true
            user.suggest
            user.can_suggest?.should be false
            user.suggest
            user.can_suggest?.should be false
        end
    end
end
