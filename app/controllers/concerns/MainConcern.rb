module MainConcern
  extend ActiveSupport::Concern
    def set_user

      if(params[:user_id] && User.find(params[:user_id]))
        @user = User.find(params[:user_id])
      else
        redirect_to main_path, alert: "Please login with valid user."
      end
    end

    def has_session
      if(session[:user_id])
        @user=User.find(session[:user_id])
      else
        redirect_to main_path, alert: "Please login with valid user."
      end

    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :name, :password,:password_confirmation)
    end

    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:user_id, :msg)
    end

    def validate_new_post
      @post = Post.new(post_params)
      if( @post.user_id!=session[:user_id])
        redirect_to main_path, alert: "Please login with right user2."
        return false
      end
    end

    def authentication
      if @user  && session[:user_id]==@user.id
        return true
      else
        redirect_to main_path, alert: "Please login with right user."
        return false
      end
    end
end