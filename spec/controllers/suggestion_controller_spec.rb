require 'rails_helper'

RSpec.describe SuggestionController, type: :controller do
    describe "#GET index" do
        it "populates an array of 'optional' snacks from op_api_snacks"
        it "renders the suggestion view"
    end
    
    describe "#POST suggest" do
        context "valid drop-down suggestion" do
            it "adds the suggested snack to the Suggestions db"
            it "updates the user's 'suggested' bool"
        end
        
        context "user already made a suggestion" do
            it "doesn't update Suggestions"
            it "stores an error in flash"
            it "doesn't change user.suggested"
        end 
        
        context "user suggests a duplicate snack" do
            it "should not update Suggestions"
            it "should report an error"
            it "doesn't use the user's one suggestion"
        end
    end
    
    describe "#POST suggest_custom" do
        context "valid custom suggestion" do
            it "doesn't add the suggested snack to the Suggestions db"
            it "sends the suggestion to the webservice"
            it "should store an error if the webservice fails"
            it "use's the user's monthly suggestion"
        end
        
        context "user suggests an invalid (missing fields) snack" do
            it "should not update Suggestions"
            it "should report an error"
            it "doesn't use the user's one suggestion"
        end
        
        context "user already made a suggestion" do
            it "doesn't update Suggestions"
            it "stores an error in flash"
            it "doesn't change user.suggested"
        end 
    end
    
    describe "opt_api_snacks" do
        it "returns an array with the 'optional' snacks from the webservice"
        it "filters out already suggested snacks"
        it "returns false and stores an error in flash if webservice fails"
    end
end