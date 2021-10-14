require 'rails_helper'
require 'monkey_patch'
# require 'movies'

describe MoviesController do 
    fixtures :movies
    describe 'Looking for movies with same director' do
        it 'should not find movies - sad path' do 
            expect(Movie).to receive(:same_director_movies).with("1").and_return([])
            get :same_director, id: 1
            response.response_code.should == 302
            expect(response).to redirect_to movies_path
        end
        it 'should find movies - happy path' do 
            expect(Movie).to receive(:same_director_movies).with("3").and_return([movies(:rise_of_the_planet_of_the_apes), movies(:dawn_of_the_planet_of_the_apes)])
            get :same_director, id: 3
            response.response_code.should == 200
        end
    end

    describe 'Testing create method' do
        it 'should create movie' do
            expect(Movie).to receive(:create!).with({'title':'dawn_of_the_planet_of_the_apes', 'director':'test'}).and_return(movies(:dawn_of_the_planet_of_the_apes))
            post :create, {:movie => {'title':'dawn_of_the_planet_of_the_apes', 'director':'test'}}
            expect(flash[:notice]).to match (/was successfully created./)
        end
    end

    describe 'Testing update method' do
        it 'should update movie' do
            expect(Movie).to receive(:find).with(movies(:dawn_of_the_planet_of_the_apes).id.to_s).and_return(movies(:dawn_of_the_planet_of_the_apes))
            expect(movies(:dawn_of_the_planet_of_the_apes)).to receive(:update_attributes!).with({'title':'dawn_of_the_planet_of_the_apes', 'director':'test'}).and_return(movies(:dawn_of_the_planet_of_the_apes))
            put :update, {:id => movies(:dawn_of_the_planet_of_the_apes).id, :movie => {'title':'dawn_of_the_planet_of_the_apes', 'director':'test'}}
            expect(flash[:notice]).to match (/was successfully updated./)
        end
    end

    describe 'Testing edit method' do
        it 'should edit movie' do
            expect(Movie).to receive(:find).with(movies(:dawn_of_the_planet_of_the_apes).id.to_s).and_return(movies(:dawn_of_the_planet_of_the_apes))
            get :edit, id: movies(:dawn_of_the_planet_of_the_apes).id
            response.response_code.should == 200
        end
    end

    describe 'Testing show method' do
        it 'should show movie' do
            expect(Movie).to receive(:find).with(movies(:dawn_of_the_planet_of_the_apes).id.to_s).and_return(movies(:dawn_of_the_planet_of_the_apes))
            get :show, id: movies(:dawn_of_the_planet_of_the_apes).id
            response.response_code.should == 200
            expect(response).to render_template("movies/show")
        end
    end

    describe 'Testing destroy method' do
        it 'should destroy movie' do
            expect(Movie).to receive(:find).with(movies(:dawn_of_the_planet_of_the_apes).id.to_s).and_return(movies(:dawn_of_the_planet_of_the_apes))
            expect(movies(:dawn_of_the_planet_of_the_apes)).to receive(:destroy)
            delete :destroy, id: movies(:dawn_of_the_planet_of_the_apes).id
            expect(flash[:notice]).to match (/Movie 'dawn_of_the_planet_of_the_apes' deleted/)
            response.response_code.should == 302
        end
    end

    describe 'Testing new method' do
        it 'should open page for new movie' do
            get :new
            response.response_code.should == 200
        end
    end

    describe 'Testing index method' do
        it 'testing without sorting and filtering' do
            expect(Movie).to receive(:all_ratings).and_return(['G', 'PG'])
            expect(Movie).to receive(:with_ratings).with(nil,['G', 'PG']).and_return([movies(:rise_of_the_planet_of_the_apes), movies(:dawn_of_the_planet_of_the_apes)])
            get :index, {home: true}
            response.response_code.should == 200
        end

        it 'testing with sorting' do
            expect(Movie).to receive(:all_ratings).and_return(['G', 'PG'])
            expect(Movie).to receive(:with_ratings).with('title',['G', 'PG']).and_return([movies(:rise_of_the_planet_of_the_apes), movies(:dawn_of_the_planet_of_the_apes)])
            get :index, {home: true, sort_column: 'title'}
            response.response_code.should == 200
        end

        it 'testing with filtering' do
            expect(Movie).to receive(:all_ratings).and_return(['G', 'PG'])
            expect(Movie).to receive(:with_ratings).with(nil,['G']).and_return([movies(:rise_of_the_planet_of_the_apes), movies(:dawn_of_the_planet_of_the_apes)])
            get :index, {home: true, ratings: {'G' => 1}}
            response.response_code.should == 200
        end

        it 'testing with sorting and filtering' do
            expect(Movie).to receive(:all_ratings).and_return(['G', 'PG'])
            expect(Movie).to receive(:with_ratings).with('release_date',['G']).and_return([movies(:rise_of_the_planet_of_the_apes), movies(:dawn_of_the_planet_of_the_apes)])
            get :index, {home: true, sort_column: 'release_date', ratings: {'G' => 1}}
            response.response_code.should == 200
        end

        it 'testing with session data' do
            expect(Movie).to receive(:all_ratings).and_return(['G', 'PG'])
            expect(Movie).to receive(:with_ratings).with(nil,['PG']).and_return([movies(:rise_of_the_planet_of_the_apes), movies(:dawn_of_the_planet_of_the_apes)])
            get :index, {}, { ratings: ['PG']}
            response.response_code.should == 200
        end
    end

end