class User < ApplicationRecord
  devise :database_authenticatable
  devise :omniauthable, omniauth_providers: [:github]

  has_many :rates, dependent: :destroy
  has_many :comments, dependent: :destroy

  def self.from_omniauth!(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      user.email = auth.info.email
      user.nickname = auth.info.nickname
      user.encrypted_password = Devise.friendly_token[0, 20]
    end
  end
end
