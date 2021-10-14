require 'rails_helper'

describe Movie do
  it "responds to same_director_movies" do
    Movie.should respond_to(:same_director_movies)
  end

  context "Happy path for same director movies" do
    it "returns a list of movies with the same director" do
      Movie.destroy_all(director: ['director_test', 'not_director_test'])
      Movie.create(title: 'test_movie',director: 'director_test')
      mov_id = Movie.where(title:'test_movie').pluck(:id)[0]
      5.times { Movie.create(director: 'director_test') }
      2.times { Movie.create(director: 'not_director_test') }
      movies =  Movie.same_director_movies(mov_id)

      expect(6).to eq movies.size()

    end
  end

    context "Sad path for same director movies" do
    it "returns empty string" do
      Movie.destroy_all(director: ['director_test', 'not_director_test'])
      Movie.create(title: 'test_movie')
      mov_id = Movie.where(title:'test_movie').pluck(:id)[0]
      5.times { Movie.create(director: 'not_director_test') }
      movies =  Movie.same_director_movies(mov_id)
      expect(0).to eq movies.size()
    end
  end

end