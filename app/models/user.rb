class User < ApplicationRecord
	# attr_accessible :name, :password_digest
	attr_accessor :remember_token, :activation_token, :reset_token

	# validates :password_digest,presence: true
	validates :password_digest, presence: true, length: { minimum: 4 }, allow_nil: true
	validates :email,presence: true
	validates :name, presence: true, uniqueness: true
	has_secure_password
	after_destroy :ensure_an_admin_remains
	has_many :favorites, dependent: :destroy
 	has_many :products, through: :favorites
 	has_many :orders
   
    # has_one :cart
 #    scope :get_by_name, ->(name){
	# where('name like ?',"%#{name}%")
	# }
	scope :search_by_keyword, -> (keyword) {
      where("users.name LIKE :keyword", keyword: "%#{sanitize_sql_like(keyword)}%") if keyword.present?
    }

    def User.digest(string)
	    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
	                                                  BCrypt::Engine.cost
	    BCrypt::Password.create(string, cost: cost)
    end

	def create_reset_digest
	    self.reset_token = User.new_token
	    update_attribute(:reset_digest,  User.digest(reset_token))
	    update_attribute(:reset_sent_at, Time.zone.now)
    end

    def User.new_token
        SecureRandom.urlsafe_base64
    end


	def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end
	  # パスワード再設定の期限が切れている場合はtrueを返す
	def password_reset_expired?
	    reset_sent_at < 2.hours.ago
	end
	def favorited_by? user
		favorites.where(user_id: user.id).exists?
		
	end

	private


	def ensure_an_admin_remains
		if User.count.zero?
			raise "最後のユーザーは削除できません"
		end		
	end
end
