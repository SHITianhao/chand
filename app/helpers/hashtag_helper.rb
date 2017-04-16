module HashtagHelper

    def self.get_hashtags(text)
        return text.scan(/(?:\s|^)(?:#(?!\d+(?:\s|$)))(\w+)(?=\s|$)/i).flatten
    end

end
