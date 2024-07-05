class ReviewsController < ApplicationController
    before_action :set_movie
    before_action :require_signin, only: [:new, :create]

    def index 
        @reviews = @movie.reviews
    end
    
    def new 
        @review = @movie.reviews.new
    end

    def create 
        @review = @movie.reviews.new(review_params)
        if @review.save
            redirect_to  movie_reviews_url(@movie), notice: "Thanks for your review!"
        else
            render :new, status: :unprocessable_entity  
        end
    end 

    def edit 
        @review = Review.find(params[:id])
    end
 
    def update
        @review = Review.find(params[:id])
        if @review.update(review_params)
          redirect_to movie_reviews_url(@movie), notice: "Review successfully updated!"
        else
          render :edit, status: :unprocessable_entity
        end
    end 

    def destroy
        @review = Review.find(params[:id])
        @review.destroy
        redirect_to movie_reviews_url(@movie), status: :see_other,
        alert: "Review successfully deleted!"
    end

    private 
    def set_movie
        @movie = Movie.find_by!(slug: params[:movie_id])
    end
    def review_params
        params.require(:review).permit(:stars, :comment, :user_id)
    end
end
