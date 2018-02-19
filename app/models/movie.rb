class Movie < ActiveRecord::Base
    def Movie.ratings
       ['G','PG','PG-13','R','NC-17']
    end
end
