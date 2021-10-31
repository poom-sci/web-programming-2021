class Post < ApplicationRecord
  belongs_to :user
  validates :msg,presence:true
  has_many :likes

  def get_all_liked_user_name
      return User.where(:id => self.likes.pluck('user_id')).pluck('name')
  end
end
