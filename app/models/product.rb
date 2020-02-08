# encording: utf-8
class Product < ApplicationRecord

	has_many :line_items
	has_many :order_items
	has_many :orders, through: :line_items
	has_many :favorites, dependent: :destroy
 	has_many :users, through: :favorites

	belongs_to :category

	before_destroy :ensure_not_referenced_by_any_line_item

    # validates :image_url, presence: true
	validates :title, :description, presence: true
	validates :price, numericality: {greater_than_or_equal_to: 0.01}
	validates :title, uniqueness: true
	validates :image_url, allow_blank: true, format: {
		with:  %r{\.(gif|jpg|png)\z}i,
		message: 'はgif,jpg,png画像のURLでなければなりません' 
	} 

	scope :get_by_name, ->(title){
		where('title like ?',"%#{title}%")
	}

	def favorited_by? user
		favorites.where(user_id: user.id).exists?
		
	end

	def total_count
		line_items.to_a.sum { |item| item.quantity}	
	end

	private

	  def ensure_not_referenced_by_any_line_item
	  	if line_items.empty?
	  		return true
	  	else
	  		errors.add(:base, '品目が存在します')
	  		return false
	  	end
	  end

end
