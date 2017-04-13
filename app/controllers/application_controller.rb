class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  # Before each controller action, make sure the user has an id stored in the session 
  before_filter :establish_user
  def establish_user; cookies[:user_id] = User.establish_user(cookies[:user_id]); end;
end
