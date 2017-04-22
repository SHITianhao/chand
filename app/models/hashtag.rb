class Hashtag < ActiveRecord::Base
    
    self.per_page = 20

    has_and_belongs_to_many :tweets, :join_table => 'hashtags_tweets'

    validates_presence_of :hashtag_text
end
