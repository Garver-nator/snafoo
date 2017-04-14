class SuggestionController < ApplicationController
    protect_from_forgery :except => [:suggest, :custom_suggest]
    
    API_URL = "https://api-snacks.nerderylabs.com/v1/snacks/?ApiKey=f5de8591-ec85-494d-b415-436cfc79f7e8"
    
    def index
        @user = User.find(cookies[:user_id])
        @optional_snacks = opt_api_snacks
        if @optional_snacks == false
            flash[:error] = "Webservice is unavailable"
        end
    end
    
    # Recieves a POST for a non-custom suggestion, checks if valid, then updates User/Suggestion
    # Currently non-custom suggestion will always be invalid due to NAT spec issue
    def suggest
        @user = User.find(cookies[:user_id])
        suggestion = params[:suggestion]
        
        if @user.can_suggest? && Suggestion.is_valid?(suggestion)
            Suggestion.create(name: suggestion["name"], last_purchase_date: suggestion["lastPurchaseDate"])
            @user.suggest
            @has_suggested = @user.has_suggested
            respond_to do |format|
                format.json{ head :ok }
                return
            end
        elsif !@user.can_suggest?
            error = "Already suggested this month"
        elsif !Suggestion.is_valid?(suggestion)
            error = "Invalid Suggestion"
        end
        
        flash[:error] = error
        respond_to do |format|
            format.json{ render :json => { :error => error }, :status => 409}
        end
    end
    
    # Recieves a POST for a non-custom suggestion, checks if valid, then sends to webservice
    def custom_suggest
        @user = User.find(cookies[:user_id])
        suggestion = params[:suggestion]
        
        if @user.can_suggest? && Suggestion.is_valid?(suggestion) && !(suggestion["location"].nil? || suggestion["location"] == "")
            message = {name: suggestion["name"], location: suggestion["location"]}.to_json
            
            # Catching unspecified errors is bad practice, but I couldn't find documentation on what errors to expect from timeouts
            begin
                api_response = HTTParty.post(API_URL, :body => message, :headers => { 'Content-Type' => 'application/json' } )
            rescue
                flash[:error] = "Webservice POST error"
                respond_to do |format|
                    format.json{ render :json => { :error => error }, :status => 409}
                    return
                end
            end
            
            if api_response.code != 200
                flash[:error] = "Webservice POST error"
                respond_to do |format|
                    format.json{ render :json => { :error => error }, :status => 409}
                    return
                end
            else
                @user.suggest
                @suggested = @user.has_suggested
                Suggestion.create(name: suggestion["name"]) # Added after change to NAT spec
                respond_to do |format|
                    format.json{ head :ok }
                    return
                end
            end
        elsif !@user.can_suggest?
            error = "Already suggested this month"
        else
            error = "Invalid Suggestion"
        end
        
        flash[:error] = error
        respond_to do |format|
            format.json{ render :json => { :error => error }, :status => 409}
        end
    end
    
    private
    
    # Returns an array of optional snacks from the webservice
    def opt_api_snacks
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
            if snack["optional"] # && !Suggestion.find_by(name: snack["name"]) (Used before NAT spec changes)
                snacks += [{name: snack["name"], last_purchase_date: snack["lastPurchaseDate"]}]
            end
        end
        return snacks
    end
end
