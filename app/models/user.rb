class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  attr_accessible :provider, :uid, :provider_name, :email, :name, :organization, :password, 
    :password_confirmation, :sms_number, :voice_number, :provider_username
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable, :token_authenticatable, :omniauthable, 
    :omniauth_providers => [:facebook, :google_oauth2]
  validates_formatting_of :email, using: :email
  validates_formatting_of :sms_number, using: :us_phone, allow_blank: true
  validates_formatting_of :voice_number, using: :us_phone, allow_blank: true
  validates_formatting_of :zip, using: :us_zip, allow_blank: true
  validates_presence_of :name
  has_many :reminders_to, class_name: "Reminder", foreign_key: "to_user_id"
  has_many :reminders_from, class_name: "Reminder", foreign_key: "from_user_id"
  has_many :things
  has_many :events

  before_validation :remove_non_digits_from_phone_numbers
  before_save :ensure_authentication_token

  def remove_non_digits_from_phone_numbers
    self.sms_number = self.sms_number.to_s.gsub(/\D/, '').to_i if self.sms_number.present?
    self.voice_number = self.voice_number.to_s.gsub(/\D/, '').to_i if self.voice_number.present?
  end

  def self.find_or_create_oauth_user(auth, signed_in_resource = nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user.nil?
      user = User.new
      user.provider_username = auth.extra.raw_info.name
      user.provider = auth.provider
      user.provider_token = auth.credentials.token
      user.provider_token_expire = auth.credentials.expires_at
      user.uid = auth.uid
      user.email = auth.info.email
      user.name = auth.info.name
      user.password = Devise.friendly_token[0,20]
      user.save!
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
