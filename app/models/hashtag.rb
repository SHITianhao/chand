class Hashtag < ActiveRecord::Base
    
    self.per_page = 20

    validates_presence_of :hashtag_text
end
