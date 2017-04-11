require 'rails_helper'

RSpec.describe Vote, type: :model do
    describe "Create votes" do
        it "should create valid votes" do
            Vote.new(:user_id => 1, :suggestion_id => 1).should be_valid
        end
        
        it "should allow multiple valid votes" do
            Vote.new(:user_id => 1, :suggestion_id => 1).should be_valid
            Vote.new(:user_id => 2, :suggestion_id => 1).should be_valid
            Vote.new(:user_id => 2, :suggestion_id => 2).should be_valid
        end
    end
    
    describe "has_voted?" do
        it "should return true if the given user has voted for a given snack" do
            Vote.create!(:user_id => 1, :suggestion_id => 1)
            Vote.has_voted?(1, 1).should == true
        end
            
        it "should return false if the user hasn't voted on a given snack" do
            Vote.has_voted?(1, 1).should == false
            Vote.create!(:user_id => 1, :suggestion_id => 1)
            Vote.has_voted?(1, 2).should == false
        end
    end
end
