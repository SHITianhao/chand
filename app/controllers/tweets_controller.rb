class TweetsController < ApplicationController

  before_action :authenticate_user!

  def create
    @tweet = Tweet.new(tweet_params) do |tweet|
      tweet.user = current_user
      tweet.parent_id = params[:parent_id]
      create_hashtags(tweet)
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
    HashtagHelper.get_hashtags(tweet.tweet_text).each do |hashtag|
      found_hashtag = Hashtag.find_by_hashtag_text(hashtag)
      if found_hashtag
        total_number = found_hashtag.total_number + 1
        found_hashtag.update(total_number:total_number)
      else
        new_hashtag = Hashtag.new({hashtag_text:hashtag, total_number:1})
        new_hashtag.save
      end
    end
  end

  private 
  def destroy_hashtags(tweet)
    HashtagHelper.get_hashtags(tweet.tweet_text).each do |hashtag|
      found_hashtag = Hashtag.find_by_hashtag_text(hashtag)
      if found_hashtag
        total_number = found_hashtag.total_number - 1
        found_hashtag.update(total_number:total_number);
      end
    end
  end

end
