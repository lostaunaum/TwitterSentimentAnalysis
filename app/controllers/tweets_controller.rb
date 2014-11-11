class TweetsController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    @authorization = Authorization.find_by(:user_id => params[:user_id])
    
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["twitter_app_id"] 
      config.consumer_secret     = ENV["twitter_app_secret"]
      config.access_token        = @authorization[:token]
      config.access_token_secret = @authorization[:secret]
    end
  end

  def create
    @user = User.find(params[:user_id])
    @authorization = Authorization.find_by(:user_id => params[:user_id])
    
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["twitter_app_id"] 
      config.consumer_secret     = ENV["twitter_app_secret"]
      config.access_token        = @authorization[:token]
      config.access_token_secret = @authorization[:secret]
    end

    def @client.get_all_tweets(user)
      collect_with_max_id do |max_id|
        options = {:count => 200, :include_rts => true}
        options[:max_id] = max_id unless max_id.nil?
        user_timeline(user, options)
      end
    end
    num_attempts = 0
    begin
      num_attempts += 1
      @tweets = @client.get_all_tweets(@client.user)
    rescue 
      @tweets = Twitter::Error::TooManyRequests
      if num_attempts % 3 == 0
        sleep(1.0/24.0) #one 24th of a second
        retry
      else
        retry
      end
    end

    @tweets.each do |tweet|
      @newtweet = Tweet.find_by(:twitterId => tweet.id.to_s)
      if @newtweet.nil?
      begin
        sentiment = AlchemyAPI.search(:sentiment_analysis, text: tweet.text)
      rescue
        sentiment = {"type" => "no value", "score" => "0"}
      end
        if sentiment.nil?
          sentiment = {"type" => "no value", "score" => "0"}
        elsif sentiment["type"] == "neutral"
          sentiment["score"] = "0"
        end
        @newtweet = Tweet.new(
          :user_id => params[:user_id],
          :tweet => tweet.text,
          :sentiment_type => sentiment["type"],
          :score => sentiment["score"],
          :twitterId => tweet.id
        )
        @newtweet.save
      end
    end
    redirect_to "/user/#{@user.id}/tweets/#{@user.id}"
  end

  def show
    @user = User.find(params[:user_id])
    @authorization = Authorization.find_by(:user_id => params[:user_id])
    
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["twitter_app_id"] 
      config.consumer_secret     = ENV["twitter_app_secret"]
      config.access_token        = @authorization[:token]
      config.access_token_secret = @authorization[:secret]
    end

    @user = User.find(params[:user_id])
    @graph = Gruff::Pie.new
    @graphBar = Gruff::Bar.new(850)
    @graphLine = Gruff::Line.new(850)
    @graphBarSide = Gruff::SideBar.new(850)
    # render "show", :layout => "application"
  end


  private

  def user_params
    params.require(:user).permit(:name)
  end

end