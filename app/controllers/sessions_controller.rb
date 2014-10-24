class SessionsController < ApplicationController

  def create
    @user = User.find_by(:nickname => auth_hash[:info][:nickname])
    if @user == nil
      @user = User.new(:name => auth_hash[:info][:name], :nickname => auth_hash[:info][:nickname], :description => auth_hash[:info][:description], :location => auth_hash[:info][:location])
      @user.save
      @authorization = Authorization.new(:provider => auth_hash[:provider], :uid => auth_hash[:uid], :user_id => @user[:id], :token => auth_hash[:credentials][:token], :secret => auth_hash[:credentials][:secret])
      @authorization.save
    else 
      @authorization = Authorization.find_by(:token => auth_hash[:credentials][:token])
    end
    session[:user_id] = @user[:id]
    @current_user = @user[:nickname];
    redirect_to "/user/#{@user.id}" 
  end

  def destroy
    session[:user_id] = nil
    flash[:message] = "Your account has been signed out."
    redirect_to "/", :notice => "Signed out!"
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

end 

