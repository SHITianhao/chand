class TweetsController < ApplicationController

  before_action :authenticate_user!

  def create
    @tweet = Tweet.new(tweet_params) do |tweet|
      tweet.user = current_user
      tweet.parent_id = params[:parent_id]
      get_hashtags(tweet)
    end
    respond_to do |format|
      format.js
    end
  end

  def update
    @tweet = Tweet.find(params[:id])
    @tweet.update(tweet_params)
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @tweet = Tweet.find(params[:id])
    @tweet_id = params[:id]
    respond_to do |format|
      format.js
    end
  end

  def reply
    @tweet = Tweet.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  private
  def tweet_params
    params.require(:tweet).permit(:tweet_text, :location, :media)
  end

  private
  def get_hashtags(tweet)
    tweet.tweet_text.scan(/(?:\s|^)(?:#(?!\d+(?:\s|$)))(\w+)(?=\s|$)/i) do |match|
      hashtag = match[0]
      found_hashtag = Hashtag.find_by_hashtag_text(hashtag)
      logger.debug hashtag
      logger.debug found_hashtag
      logger.debug params
      if !found_hashtag 
        logger.debug "Hashtag #{hashtag} not found"
        found_hashtag = Hashtag.new({hashtag_text:hashtag})
      end
    end
    
  end

end
