class MoviesController < ApplicationController
    before_action :set_movie, only: %i[ show edit update destroy]
    before_action :require_signin, except: [:index, :show]
    before_action :require_admin, except: [:index, :show]
    def index
        case params[:filter]
        when "upcoming"
          @movies = Movie.upcoming
        when "recent"
          @movies = Movie.recent
        else
          @movies = Movie.released
        end
    end

    def show
        @review = @movie.reviews.new
        @fans = @movie.fans
        @genres = @movie.genres.order(:name)
        if current_user
            @favorite = current_user.favorites.find_by(movie_id: @movie.id)
        end
    end

    def edit
    end

    def new
        @movie = Movie.new
    end

    def create
        @movie = Movie.new(movie_params)
        if @movie.save
            redirect_to @movie, notice: "Movie successfully created!"
        else
            render :new, status: :unprocessable_entity
        end
    end

    def destroy
        @movie.destroy
        redirect_to movies_url, status: :see_other,
        alert: "Movie successfully deleted!"
    end

    def update
        if @movie.update(movie_params)
          redirect_to @movie, notice: "Movie successfully updated!"
        else
          render :edit, status: :unprocessable_entity
        end
    end    

    private

    def set_movie
        @movie = Movie.find_by!(slug: params[:id])
        
    end
    
    def movie_params
        params.require(:movie).permit(:title, :rating, :total_gross, :description, :released_on, :director, :duration, :image_file_name, genre_ids: [])
    end

    def is_movie_faved?(movie)
        if movie.fans.include?(current_user)
            return true
        else
            return false
        end
    end
    helper_method :is_movie_faved?
end
