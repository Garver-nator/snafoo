require 'rails_helper'

RSpec.describe SuggestionController, type: :controller do
    describe "#GET index" do
        before :each do 
            allow_any_instance_of(SuggestionController).to receive(:opt_api_snacks).and_return(["Apples", "Chips"])
        end
        
        it "populates an array of 'optional' snacks from op_api_snacks" do
            expect{ get :index }.to change{ assigns(:optional_snacks) }.to(["Apples", "Chips"])
        end
        
        it "renders the suggestion view" do
            get :index
            response.should render_template :suggestion
        end
    end
    
    describe "#POST suggest" do
        context "valid drop-down suggestion" do
            before :each do 
                @user = FactoryGirl.create(:user)
                @pretzels = FactoryGirl.create(:suggestion, name: "Pretzels")
            end
            
            it "adds the suggested snack to the Suggestions db" do
                expect{
                    xhr :post, :suggest, {:format => "js", user_id: @user.id, suggestion: FactoryGirl.attributes_for(:suggestion)}
                }.to change(Suggestion, :count).by(1)
            end
            
            it "updates the user's 'has_suggested' bool" do
                user = User.create!()
                expect{
                    xhr :post, :suggest, {:format => "js", user_id: user.id, suggestion: FactoryGirl.attributes_for(:suggestion)}
                }.to change(user, :has_suggested).from(false).to(true)
            end
            
            it "doesn't render anything" do
                xhr :post, :suggest, {:format => "js", user_id: @user.id, suggestion: FactoryGirl.attributes_for(:suggestion)}
                expect(response).to render_template(nil)
            end
        end
        
        context "user already made a suggestion" do
            before :each do 
                @user = FactoryGirl.create(:user, has_suggested: true)
            end
            
            it "doesn't update Suggestions" do
                expect{
                    xhr :post, :suggest, {:format => "js", user_id: @user.id, suggestion: FactoryGirl.attributes_for(:suggestion)}
                }.to_not change(Suggestion, :count)
            end
                
            it "stores an error in flash" do
                xhr :post, :suggest, {:format => "js", user_id: @user.id, suggestion: FactoryGirl.attributes_for(:suggestion)}
                expect(flash[:error]).to be_present
            end
                
            it "doesn't change user.suggested" do
                expect{
                    xhr :post, :suggest, {:format => "js", user_id: @user.id, suggestion: FactoryGirl.attributes_for(:suggestion)}
                }.to_not change(@user, has_suggested)
            end
        end 
        
        context "user suggests a duplicate snack" do
            before :each do 
                @user = FactoryGirl.create(:user)
                @pretzels = FactoryGirl.create(:suggestion, name: "Pretzels")
                Suggestion.create!(name: "Pretzels")
            end
            
            it "should not update Suggestions" do
                expect{
                    xhr :post, :suggest, {:format => "js", user_id: @user.id, suggestion: FactoryGirl.attributes_for(:suggestion)}
                }.to_not change(Suggestion, :count)
            end
                
            it "should report an error" do
                xhr :post, :suggest, {:format => "js", user_id: @user.id, suggestion: FactoryGirl.attributes_for(:suggestion)}
                expect(flash[:error]).to be_present
            end
            
            it "doesn't use the user's suggestion" do
                expect{
                    xhr :post, :suggest, {:format => "js", user_id: @user.id, suggestion: FactoryGirl.attributes_for(:suggestion)}
                }.to_not change(@user, has_suggested)
            end
        end
    end
    
    describe "#POST custom_suggest" do
        context "valid custom suggestion" do
            before :each do 
                @user = FactoryGirl.create(:user)
                @pretzels = FactoryGirl.create(:suggestion, name: "Pretzels")
                stub_request(:any, /api-snacks.nerderylabs.com/).to_return(body: "", status: "200", headers: {})
            end
            
            it "doesn't add the suggested snack to the Suggestions db" do
                expect{
                    xhr :post, :custom_suggest, {:format => "js", user_id: @user.id, suggestion: FactoryGirl.attributes_for(:suggestion)}
                }.to_not change(Suggestion, :count)
            end
                
            it "should store an error if the webservice fails" do
                stub_request(:any, /api-snacks.nerderylabs.com/).to_return(body: "", status: "Not 200", headers: {})
                xhr :post, :custom_suggest, {:format => "js", user_id: @user.id, suggestion: FactoryGirl.attributes_for(:suggestion)}
                expect(flash[:error]).to be_present
            end
                
            it "uses the user's monthly suggestion" do
                expect{
                    xhr :post, :custom_suggest, {:format => "js", user_id: @user.id, suggestion: FactoryGirl.attributes_for(:suggestion)}
                }.to change(@user, has_suggested).to(true)
            end
        end
        
        context "user suggests an invalid (missing fields) snack" do
            before :each do 
                @user = FactoryGirl.create(:user)
                @no_name_snack = FactoryGirl.create(:suggestion, name: nil)
                stub_request(:any, /api-snacks.nerderylabs.com/).to_return(body: "", status: "Not 200", headers: {}) # Should never be sent in this context
            end
            
            it "should not update Suggestions" do
                expect{
                    xhr :post, :custom_suggest, {:format => "js", user_id: @user.id, suggestion: FactoryGirl.attributes_for(@no_name_snack)}
                }.to_not change(Suggestion, :count)
            end
            
            it "should report an error" do
                xhr :post, :custom_suggest, {:format => "js", user_id: @user.id, suggestion: FactoryGirl.attributes_for(:suggestion)}
                expect(flash[:error]).to be_present
            end
                
            it "doesn't use the user's one suggestion" do
                expect{
                    xhr :post, :custom_suggest, {:format => "js", user_id: @user.id, suggestion: FactoryGirl.attributes_for(:suggestion)}
                }.to_not change(@user, has_suggested)
            end
        end
        
        context "user already made a suggestion" do
            before :each do 
                @user = FactoryGirl.create(:user, has_suggested: true)
                @no_name_snack = FactoryGirl.create(:suggestion, name: nil)
                stub_request(:any, /api-snacks.nerderylabs.com/).to_return(body: "", status: "Not 200", headers: {}) # Should never be sent in this context
            end
            
            it "doesn't update Suggestions" do
                expect{
                    xhr :post, :custom_suggest, {:format => "js", user_id: @user.id, suggestion: FactoryGirl.attributes_for(@no_name_snack)}
                }.to_not change(Suggestion, :count)
            end
                
            it "stores an error in flash" do
                xhr :post, :custom_suggest, {:format => "js", user_id: @user.id, suggestion: FactoryGirl.attributes_for(:suggestion)}
                expect(flash[:error]).to be_present
            end
            
            it "doesn't change user.has_suggested" do
                expect{
                    xhr :post, :custom_suggest, {:format => "js", user_id: @user.id, suggestion: FactoryGirl.attributes_for(:suggestion)}
                }.to_not change(@user, has_suggested)
            end
        end 
    end
    
    describe "opt_api_snacks" do
         before :each do
            @controller = SuggestionController.new
            @response = '[{"id": 6, "name": "Chips", "optional": true, "purchaseLocations": "Store", "purchaseCount": 0, "lastPurchaseDate": null},
                        {"id": 17, "name": "Jerky", "optional": false, "purchaseLocations": "B Store", "purchaseCount": 500, "lastPurchaseDate": "10/10/2010"}]'
                        
            stub_request(:any, /api-snacks.nerderylabs.com/).to_return(body: @response, status: "200", headers: {})
        end
        
        it "returns an array with the 'optional' snacks from the webservice" do
            @controller.send(:opt_api_snacks).should be_an_instance_of(Array)
            @controller.send(:opt_api_snacks).should_not include("Jerky")
        end
            
        it "filters out already suggested snacks" do
            Suggestion.create!(name: "Chips")
            @controller.send(:opt_api_snacks).should_not include("Chips")
        end
        
        it "returns false if webservice fails" do
            stub_request(:any, /api-snacks.nerderylabs.com/).to_return(body: @response, status: "Not 200", headers: {})
            @controller.send(:opt_api_snacks).should be_false
        end
    end
end