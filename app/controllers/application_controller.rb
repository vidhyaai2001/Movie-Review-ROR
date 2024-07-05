class ApplicationController < ActionController::Base
private
    def require_signin
        session[:intended_url] = request.url
        unless current_user
            redirect_to signin_path, alert: "Please sign in first!"
        end
    end

    def require_correct_user
        unless current_user.id == params[:id]
            redirect_to signin_path, alert: "Please sign in first!"
        end
    end
    
    def current_user
        @current_user ||= User.find(session[:user_id]) if  session[:user_id]
    end
    helper_method :current_user #to use current_user method as view helpers

    def current_user?(user)
        current_user == user
    end
    helper_method :current_user?

    def current_user_admin?
        current_user && current_user.admin? 
    end
    helper_method :current_user_admin?

    def require_admin
        unless current_user_admin?
            redirect_to root_path, alert: "Unauthorized access!"
        end
    end
end
