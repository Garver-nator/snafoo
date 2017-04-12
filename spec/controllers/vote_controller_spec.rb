require 'rails_helper'

RSpec.describe VoteController, type: :controller do
    describe "#GET index" do
        before :each do 
            allow_any_instance_of(VoteController).to receive(:api_snacks).and_return(["Apples", "Chips"])
            @pretzels = FactoryGirl.create(:suggestion, name: "Pretzels")
            @cookies = FactoryGirl.create(:suggestion, name: "Cookies")
            @user = FactoryGirl.create(:user, remaining_votes: 2)
        end
        
        it "populates an array of snacks via api_snacks" do
            expect{ get :index }.to change{ assigns(:snacks) }.to(["Apples", "Chips"])
        end
        
        it "populates an array of suggestions from the model" do 
            expect{ get :index }.to change{ assigns(:suggestions) }.to([@cookies, @pretzels])
        end
        
        it "puts an error in flash if the webservice is down" do
            allow_any_instance_of(VoteController).to receive(:api_snacks).and_return(false)
            get :index
            expect(flash[:error]).to be_present
        end
            
        it "finds the user's remaining votes" do
            expect{ get :index, user_id: @user.id }.to change{ assigns(:remaining_votes) }.to(@user.remaining_votes)
        end
            
        it "renders the vote view" do
            get :index
            response.should render_template :index
        end
    end
    
    describe "#POST vote" do
        context "with a valid vote" do
            before :each do 
                @user = FactoryGirl.create(:user, remaining_votes: 3)
                @pretzels = FactoryGirl.create(:suggestion, name: "Pretzels")
            end

            it "saves the new vote in the database" do
                expect{
                    xhr :post, :vote, {:format => "js", user_id: @user.id, suggestion: FactoryGirl.attributes_for(:suggestion)}
                }.to change(Vote, :count).by(1)
            end
            
            it "updates the Suggestion entry (+1 vote count)" do
                expect{
                    xhr :post, :vote, {:format => "js", user_id: @user.id, suggestion: FactoryGirl.attributes_for(:suggestion)}
                }.to change(@pretzels, :votes).by(1)
            end
                
            it "decrements the user's remaining vote count" do
                user = User.create!()
                expect{
                    xhr :post, :vote, {:format => "js", user_id: user.id, suggestion: FactoryGirl.attributes_for(:suggestion)}
                }.to change(user, :remaining_votes).by(1)
            end
                
            it "responds with a successful AJAX response" do
                xhr :post, :vote, {:format => "js", user_id: @user.id, suggestion: FactoryGirl.attributes_for(:suggestion)}
                expect(response).to be_success
            end
            
            it "doesn't render anything" do
                xhr :post, :vote, {:format => "js", user_id: @user.id, suggestion: FactoryGirl.attributes_for(:suggestion)}
                expect(response).to render_template(nil)
            end
        end
        
        context "with no remaining votes" do
            it "responds with 'no remaining votes' failure response" do
                user = FactoryGirl.create(:user, remaining_votes: 0)
                xhr :post, :vote, {:format => "js", user_id: user.id, suggestion: FactoryGirl.attributes_for(:suggestion)}
                expect(response).to be_failure
            end
        end
        
        context "the snack was already voted on" do
            it "responds with 'already voted' failure response" do
                pretzels = FactoryGirl.create(:suggestion, name: "Pretzels")
                user = FactoryGirl.create(:user)
                vote = FactoryGirl.create(:vote, user_id: user.id, suggestion_id: pretzels.id)
                xhr :post, :vote, {:format => "js", user_id: user.id, suggestion: FactoryGirl.attributes_for(:suggestion)}
                expect(response).to be_failure
            end
        end
    end
    
    describe "api_snacks" do
        before :each do
            @controller = VoteController.new
            @response = '[{"id": 6, "name": "Chips", "optional": true, "purchaseLocations": "Store", "purchaseCount": 0, "lastPurchaseDate": null},
                        {"id": 17, "name": "Jerky", "optional": false, "purchaseLocations": "B Store", "purchaseCount": 500, "lastPurchaseDate": "10/10/2010"}]'
                        
            stub_request(:any, /api-snacks.nerderylabs.com/).to_return(body: @response, status: "200", headers: {})
        end
        
        it "returns an array with snacks from the webservice" do
            @controller.send(:api_snacks).should be_an_instance_of(Array)
        end
        
        it "filters out optional snacks" do
            @controller.send(:api_snacks).should_not include("Chips")
        end
            
        it "returns false if the webservice is down" do
            stub_request(:any, /api-snacks.nerderylabs.com/).to_return(body: @response, status: "Not 200", headers: {})
            @controller.send(:api_snacks).should be_false
        end
    end
        
end
