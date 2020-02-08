class Order < ApplicationRecord
	PAYMENT_TYPES = ["現金","クレジットカード","注文書"]
	has_many :line_items, dependent: :destroy
	has_many :order_items, dependent: :destroy

	belongs_to :user


	validates :name, :address, :email,:user_id, presence: true
	validates :pay_type, inclusion: PAYMENT_TYPES

	default_scope -> { order(created_at: :desc) }

    # attr_protected :id
    # scope :search_names_or, lambda { |search_word| where("family_name = ? or first_name = ?", search_word, search_word) }

	# scope :get_by_name, ->(name){
	# 	where('name like ?',"%#{name}%")}
	# scope :get_by_address, ->(address){
	# 	where('address like ?',"%#{address}%")}
  #   scope :get_by_name, ->(name){
		# where('name like ?',"%#{name}%")}
	# attr_protected :name
	# scope :search_names_or, lambda { |search_word| where("name = ? or address = ?", search_word, search_word) }
    scope :search_by_keyword, -> (keyword) {
      where("(orders.name LIKE :keyword) OR (orders.address LIKE :keyword)", keyword: "%#{sanitize_sql_like(keyword)}%") if keyword.present?
    }



	def add_line_items_from_cart(cart)
		cart.line_items.each do |item|
			item.cart_id = nil
			line_items << item
		end
	end
	def total_price
		line_items.to_a.sum { |item| item.total_price }
	end
	def total_count
		line_items.to_a.sum { |item| item.quantity}
	end
end
