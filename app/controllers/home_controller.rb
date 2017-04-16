class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @tweets = Tweet.where("user_id in (?) OR user_id = ?", current_user.friend_ids, current_user).paginate(page: params[:page]).order('created_at DESC')
    @trends = Hashtag.where("total_number > ?", 0).order('total_number DESC').limit(10)
  end
end
