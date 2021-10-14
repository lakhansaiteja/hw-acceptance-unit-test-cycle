class Movie < ActiveRecord::Base
  def self.same_director_movies(id)
       director = Movie.where(id:id).pluck(:director)[0]
       if director!=nil && director!=""
           Movie.where(director:director)
       else
           return []
       end
  end
end
