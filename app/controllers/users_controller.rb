class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :require_signin, except: [:new, :create, :destroy]
    before_action :require_correct_user, only: [:edit, :update]
    before_action :require_admin, only: [:destroy]
    def index
        @users = User.all
        
    end
    
    def show
        @reviews = @user.reviews
        @favorite_movies = @user.favorite_movies
    end

    def new
        @user = User.new
    end

    def edit
       
    end

    def update
        if @user.update(user_params)
            redirect_to @user, notice: "Account sucessfully updated!"
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def create
        @user = User.new(user_params)
        if @user.save
            redirect_to @user, notice: "Thanks for signing up!"
        else
            render :new, status: :unprocessable_entity
        end
    end

    def destroy
        @user.destroy
        if current_user_admin?
            session[:user_id] = nil
        end
        redirect_to users_url, status: :see_other,
        alert: "Account successfully deleted!"
    end

    private

        def set_user
            @user = User.find(params[:id])
        end
        
        def user_params
            params.require(:user).permit(:name, :email, :password, :passowrd_confirmation)
        end

        def require_correct_user
            @user = User.find(params[:id])
            redirect_to movies_url unless current_user?(@user)
        end
end
