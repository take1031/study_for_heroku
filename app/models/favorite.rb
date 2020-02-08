class Favorite < ApplicationRecord
	belongs_to :product
	belongs_to :user

	validates :user, presence: true
	validates :user_id, uniqueness:{scope: :product_id}
	validates :product, presence: true

    def favorited_by? user
		favorites.where(user_id: user.id).exists?
		
	end

end
