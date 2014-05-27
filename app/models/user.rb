class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:github]

  validates :username, uniqueness: true

  def self.find_or_create_for_github_oauth(auth)
    auth_token = auth.credentials.token
    user = User.where(uid: auth.uid).first_or_create do |user|
      user.uid = auth.uid
      user.provider = auth.provider
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.username = auth.info.name
      # user.gravatar = auth.extra.raw_info.gravatar_id
    end
    # unless user.github_access_token == auth_token
    #   user.update_attribute(:github_access_token, auth_token)
    # end
    user
  end
end
