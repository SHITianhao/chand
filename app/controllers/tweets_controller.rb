class TweetsController < ApplicationController

  before_action :authenticate_user!

  def create
    @tweettemp = Tweet.new(tweet_params)
    @notifications = Notifications.new(username:current_user.username,text: @tweettemp.tweet_text,touser:get_tagged_user(@tweettemp), msgtype:'tweet')
    @notifications.save
    @tweet = Tweet.new(tweet_params) do |tweet|
      tweet.user = current_user
      tweet.parent_id = params[:parent_id]
      create_hashtags(tweet)
      logger.debug "############# #{tweet.hashtags.size} ##########"
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
    logger.debug "########### Tweet DELETE ########"
    @tweet = Tweet.find(params[:id])
    destroy_hashtags(@tweet)
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
  def create_hashtags(tweet)
    get_hashtags(tweet.tweet_text).each do |hashtag|
      found_hashtag = Hashtag.find_by_hashtag_text(hashtag)
      if found_hashtag
        total_number = found_hashtag.total_number + 1
        found_hashtag.update(total_number:total_number)
      else
        found_hashtag = Hashtag.new({hashtag_text:hashtag, total_number:1})
        found_hashtag.save
      end
      tweet.hashtags<<found_hashtag
      logger.debug "############# #{tweet.hashtags.size} ##########"
    end
  end

  private 
  def destroy_hashtags(tweet)
    get_hashtags(tweet.tweet_text).each do |hashtag|
      found_hashtag = Hashtag.find_by_hashtag_text(hashtag)
      if found_hashtag
        total_number = found_hashtag.total_number - 1
        found_hashtag.update(total_number:total_number);
      end
    end
  end

  private 
  def get_hashtags(text)
    return text.scan(/(?:\s|^)(?:#(?!\d+(?:\s|$)))(\w+)(?=\s|$)/i).flatten
  end
 
  def get_tagged_user(tweet)
     tweet.tweet_text.match(/@(\w+)/).to_s
  end
    

end
