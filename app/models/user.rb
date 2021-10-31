class User < ApplicationRecord
	has_many :posts
	has_secure_password
	validates :email,presence:true,uniqueness:true
	validates :name, presence: true,uniqueness:true,length: {minimum: 4, maximum: 10}
	validates :password,length: {minimum: 8}
	validates :password_digest,presence:true
	validates_confirmation_of :password

	has_many :follower, class_name: 'Follow', foreign_key: 'follower_id'
  	has_many :followee, class_name: 'Follow', foreign_key: 'followee_id'
  	has_many :likes, dependent: :destroy


  	def get_all_follwee_posts
	    return Post.where(:user_id => Follow.where(follower_id:id).pluck('followee_id')).order("created_at DESC")
  	end

  	def get_not_follwees
	    return User.where.not(:id => Follow.where(follower_id:id).pluck('followee_id').push(id)).order("created_at DESC")
  	end
end
