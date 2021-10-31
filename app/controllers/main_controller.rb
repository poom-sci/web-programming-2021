class MainController < ApplicationController
    include MainConcern

    before_action :set_user, only: %i[ feed create_post other_user ]
    before_action :authentication, only: %i[feed create_post other_user ]
    before_action :validate_new_post, only: %i[ create_new_post ]
    before_action :has_session, only: %i[ profile ]
    before_action :set_post, only: %i[  destroy_post ]


  def main
    session.delete(:user_id)
    if(!@user) 
      @user=User.new
    end
  end

  def login
    @email= params[:user][:email]
    @password= params[:user][:password]

    @user = User.find_by(email:@email)

    respond_to do |format|
      if @user && @user.authenticate(@password)
        session[:user_id] = @user.id
        format.html { redirect_to '/feed?user_id='+@user.id.to_s, notice: "User was successfully login." }
        format.json { render json: @user }
      else
        session.delete(:user_id)
        format.html { redirect_to '/main',alert: "Your email or password is invalid." }
        format.json { render json: @user.errors,status: :unprocessable_entity}
      end
    end
 
  end

  def logout
    respond_to do |format|
    
      session[:user_id] = nil
      format.html { redirect_to '/main', notice: "User logout successfully." }
      # format.json { render json: @user }
    
    end
  end

  def register
      @user=User.new
  end

  def register_create
      @user = User.new(user_params)    

      respond_to do |format|
        if @user.save
          format.html { redirect_to '/main', notice: "User was successfully created." }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { render :register , status: :unprocessable_entity  }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
  end

  def create_post
    @post= Post.new
    @post.user_id=params[:user_id]
  end

  def create_new_post
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to '/feed?user_id='+@post.user_id.to_s, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :create_post, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end


  def feed
    @feed_posts=@user.get_all_follwee_posts
  end

  def other_user
    @arr=@user.follower.map { |follow|
      follow.followee_id
    }
    @arr.push(@user.id)
    @not_follow_users_list=@user.get_not_follwees
  end


  def profile
    if(!params[:name])
      @profile_user = @user
    elsif(params[:name]==@user.name)
      respond_to do |format|
        format.html { redirect_to '/profile' }
      end
    else
      @profile_user = User.find_by(name:params[:name])
      @isFollowed=Follow.find_by(follower_id:@user.id,followee_id:@profile_user.id)

    end
  end

  def follow
    @user=User.find(params[:user][:id])
    @to_action_user=User.find(params[:user_id])
    puts(params[:user][:id])
    puts(session[:user_id])
    if(session[:user_id].to_s!=params[:user][:id].to_s)
      respond_to do |format|
        session[:user_id] = nil
        format.html { redirect_to '/main', alert: "User is invalid" }
      end
    else

      if(params[:commit]=='Follow')
        Follow.create(follower:@user,followee:@to_action_user).save
        respond_to do |format|
        format.html { redirect_to '/feed?user_id='+@user.id.to_s, notice: "Follow "+@to_action_user.name+" successfully" }
      end
      elsif(params[:commit]=='Unfollow')
        Follow.find_by(follower:@user,followee:@to_action_user).destroy
          respond_to do |format|
          format.html { redirect_to '/feed?user_id='+@user.id.to_s, notice: "Unfollow "+@to_action_user.name+" successfully" }
        end
      end
    end
  end

  def destroy_post
    if(@post.id==session[:user_id])
      respond_to do |format|
      format.html { redirect_to '/main', alert: "User is not owner of post." }
      format.json { head :no_content }
      end
    else
      @post.destroy
      respond_to do |format|
        format.html { redirect_to '/profile', notice: "Post was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  end

  def already_liked?
    Like.where(user_id: current_user.id, post_id:params[:post_id]).exists?
  end

  def like
    @user=User.find(params[:user][:id])
    @post=Post.find(params[:post_id])

    if(session[:user_id].to_s!=params[:user][:id].to_s)
      respond_to do |format|
        session[:user_id] = nil
        format.html { redirect_to '/main', alert: "User is invalid" }
      end
    else

      if(params[:commit]=='Like')
        Like.create(user:@user,post:@post).save
        respond_to do |format|
        format.html { redirect_to '/feed?user_id='+@user.id.to_s, notice: "Like "+@post.msg+" successfully" }
      end
      elsif(params[:commit]=='Unlike')
        Like.find_by(user:@user,post:@post).destroy
          respond_to do |format|
          format.html { redirect_to '/feed?user_id='+@user.id.to_s, notice: "Unlike "+@post.msg+" successfully" }
        end
      end
    end
  end

end
