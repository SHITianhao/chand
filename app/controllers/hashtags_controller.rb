class HashtagsController < ApplicationController

  before_action :authenticate_user!

  def index
    @hashtag_text = params[:tag]
    @hashtag_id = params[:id]
    if !@hashtag_id
      @hashtag_id = Hashtag.find_by(hashtag_text: @hashtag_text)
    end
    @trends = Hashtag.where("total_number > ?", 0).order('total_number DESC').limit(10)

    @tweets = Tweet.joins(:hashtags).where("hashtag_id = ?", @hashtag_id).paginate(page: params[:page]).order('created_at DESC') 
    # logger.debug @tweets[0].tweet_text
  end
end
