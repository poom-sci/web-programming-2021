class User < ApplicationRecord
	has_many :posts
	has_secure_password
	validates :email,presence:true,uniqueness:true
	validates :name, presence: true,uniqueness:true,length: {minimum: 4, maximum: 10}
	validates :password_digest,presence:true
	validates_confirmation_of :password

	has_many :follower, class_name: 'Follow', foreign_key: 'follower_id'
  	has_many :followee, class_name: 'Follow', foreign_key: 'followee_id'
end
