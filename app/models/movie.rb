class Movie < ActiveRecord::Base
    def self.ratings
        Movie.select(:rating).distinct.inject([]) { |x, y| x.push y.rating }
    end
end
