require 'rails_helper'

RSpec.describe Suggestion, type: :model do
    describe "Create Suggestions" do
        it "should create valid suggestions" do
            Suggestion.new(:name => "Chips").should be_valid
        end
        
        it "should allow multiple unique suggestions" do
            Suggestion.new(:name => "Chips").should be_valid
            Suggestion.new(:name => "Apples").should be_valid
        end
        
        it "should check for unique names" do
            Suggestion.create!(:name => "Chips").should be_valid
            expect{Suggestion.create!(:name => "Chips")}.to raise_error(ActiveRecord::RecordInvalid)
        end
        
        it "should default to 0 votes" do
            chips = Suggestion.create!(:name => "Chips")
            chips.votes.should == 0
        end
        
    end
    
    describe "Voting" do
        it "should keep track of votes correctly" do
            chips = Suggestion.create!(:name => "Chips")
            apples = Suggestion.create!(:name => "Apples")
            chips.votes.should == 0
            chips.voted
            chips.votes.should == 1
            chips.voted
            chips.votes.should == 2
            apples.voted
            apples.votes.should == 1
            chips.votes.should == 2
        end
    end
    
    describe "Listing suggestions" do
        it "should list suggestions in alphabetical order" do
            chips = Suggestion.create!(:name => "Chips")
            apples = Suggestion.create!(:name => "Apples")
            pretzels = Suggestion.create!(:name => "Pretzels")
            
            Suggestion.suggestions.should == ["Apples", "Chips", "Pretzels"]
        end
    end
end
