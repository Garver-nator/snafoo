require 'rails_helper'

RSpec.describe VoteController, type: :controller do
    describe "#GET index" do
        it "populates an array of snacks via api_snacks"
        it "populates an array of suggestions from the model"
        it "puts an error in flash if the webservice is down"
        it "finds the user's remaining votes"
        it "renders the vote view"
    end
    
    describe "#POST vote" do
        context "with a valid vote" do
            it "saves the new vote in the database"
            it "updates the Suggestion entry (+1 vote count)"
            it "decrements the user's remaining vote count"
            it "responds with a successful AJAX response"
            it "doesn't render anything"
        end
        
        context "with no remaining votes" do
            it "responds with 'no remaining votes' failure response"
            it "doesn't allow changing votes"
        end
        
        context "the snack was already voted on" do
            it "responds with 'already voted' failure response"
        end
    end
    
    describe "api_snacks" do
        it "returns an array with snacks from the webservice"
        it "returns false if the webservice is down"
    end
        
end
