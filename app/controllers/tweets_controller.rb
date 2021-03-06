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
      # sidekick and delay-job could be a resource to imrpove user experience in this section of the code
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

    user = User.find(params[:user_id])
    tweets = Tweet.where(:user_id => params[:id]).all 

###################CHART STUFFFFFF##########################

    @negative = {:score => 0, :count => 0} 
    @neutral = {:score => 0, :count => 0} 
    @positive = {:score => 0, :count => 0} 
    @max_score_positive = {:max => 0, :posTweetText => ""} 
    @max_score_negative = {:max => 0, :negTweetText => ""} 
    @scores_array = [] 
    @result = "" 

    tweets.each do |tweet| 
    @scores_array << tweet[:score] 
      if tweet[:sentiment_type] == "positive" 
        @positive[:score] += tweet[:score] 
        @positive[:count] += 1 

        if @max_score_positive[:max] < tweet[:score]
          @max_score_positive[:max] = tweet[:score] 
          @max_score_positive[:posTweetText] = tweet[:tweet]
        end 
      end 

      if tweet[:sentiment_type] == "negative" 
        @negative[:score] += tweet[:score] 
        @negative[:count] += 1 

        if @max_score_negative[:max] > tweet[:score]
          @max_score_negative[:max] = tweet[:score] 
          @max_score_negative[:negTweetText] = tweet[:tweet]
        end 
      end 

      if tweet[:sentiment_type] == "neutral" 
        @neutral[:score] += tweet[:score] 
        @neutral[:count] += 1 
      end 
    end 

    if @positive[:count] > @negative[:count] && @positive[:count] > @neutral[:count] 
      @result = "Positive" 
    elsif @negative[:count] > @positive[:count] && @negative[:count] > @neutral[:count] 
      @result = "Negative" 
    else 
      @result = "Neutral" 
    end 

    if @positive[:count] == 0
      @positive[:count] = 1 
    elsif @negative[:count] == 0 
      @negative[:count] = 1 
    end 

    @positiveAverage = view_context.number_with_precision((@positive[:score]/@positive[:count])*100, :precision => 2).to_i
    @negativeAverage = -view_context.number_with_precision((@negative[:score]/@negative[:count])*100, :precision => 2).to_i
    total_count = @positive[:count] + @negative[:count] + @neutral[:count]

  end
  
  private

  def user_params
    params.require(:user).permit(:name)
  end
end