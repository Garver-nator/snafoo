class VoteController < ApplicationController
    protect_from_forgery :except => [:vote]
    API_URL = "https://api-snacks.nerderylabs.com/v1/snacks/?ApiKey=f5de8591-ec85-494d-b415-436cfc79f7e8"
    
    def index
        @user = User.find(cookies[:user_id])
        @snacks = api_snacks
        @suggestions = Suggestion.suggestions
        @remaining_votes = @user.remaining_votes
        
        if @snacks == false
            flash[:error] = "Webservice is unavailable"
        end
    end
    
    def vote
        @user = User.find(cookies[:user_id])
        suggestion = Suggestion.find_by(name: params[:suggestion_name])
        
        if suggestion.nil?
            flash[:error] = "Invalid vote"
            respond_to do |format|
                format.json{ render :json => { :error => "Invalid vote" }, :status => 400}
            end
            return
        elsif !@user.can_vote?
            flash[:error] = "Out of votes"
            respond_to do |format|
                format.json{ render :json => { :error => "You may not vote again until next month" }, :status => 409}
            end
            return
        elsif Vote.has_voted?(@user.id, suggestion.id)
            flash[:error] = "Already voted for this"
            respond_to do |format|
                format.json{ render :json => { :error => "You already voted for this" }, :status => 409}
            end
            return
        end
        
        suggestion.voted
        @user.vote
        Vote.create(user_id: @user.id, suggestion_id: suggestion.id)
        
        # Needed to track votes in rspec:
        @user_votes = @user.remaining_votes
        @suggestion_votes = suggestion.votes
        
        respond_to do |format|
            format.json{ head :ok }
            return
        end
    end
    
    private
    
    # API requests should be handled by a separate class, but this is quick for prototyping
    def api_snacks
        # It's bad practice to catch unspecified errors like this, but I was unclear what error to expect from a timeout
        begin
            api_response = HTTParty.get(API_URL)
        rescue
            return false
        end
        return false if api_response.code != 200
        
        body = JSON.parse(api_response.body)
        snacks = []
        for snack in body do
            if !snack["optional"]
                snacks += [snack["name"]]
            end
        end
        return snacks
    end
end
