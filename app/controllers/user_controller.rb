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
      config.consumer_key        = "kMTcEE1rZrouv1zh6car30nw8"
      config.consumer_secret     = "zpTobHFDGK97jT9WKH7F4Y4mcj7eN3Vp5GoeTHWo8tnhBI5H1b"
      config.access_token        = @authorization[:token]
      config.access_token_secret = @authorization[:secret]
    end
  end


  private
  def user_params
    params.require(:user).permit(:name)
  end

end