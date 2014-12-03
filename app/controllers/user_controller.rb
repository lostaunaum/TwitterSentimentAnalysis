class UserController < ApplicationController
  def index
    if !session[:user_id].nil?
      @user = User.find(session[:user_id])
    else
      redirect_to '/login'
    end
  end

  def show
    @user = User.find(params[:id])
    @authorization = Authorization.find_by(:user_id => params[:id])

    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["twitter_app_id"] 
      config.consumer_secret     = ENV["twitter_app_secret"]
      config.access_token        = @authorization[:token]
      config.access_token_secret = @authorization[:secret]
    end
  end


  private
  def user_params
    params.require(:user).permit(:name)
  end

end