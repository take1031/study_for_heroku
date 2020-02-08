class CombineItemsInCart < ActiveRecord::Migration[5.1]
  def up
  	#カート内に1つの商品に対して複数の品目があった場合は、１つ目の品目に置き換える
  	Cart.all.each do |cart|
  		#カート内の各商品の数をカウントする
  		sums = cart.line_items.group(:product_id).sum(:quantity)

  		sums.each do |product_id, quantity|
  			if quantity > 1
  				cart.line_items.where(product_id: product_id).delete_all

  				cart.line_items.create(product_id: product_id, quantity: quantity)
  			end
  		end
  	end
  end

  def down
  	LineItem.where("quantity>1").each do |line_item|
  		line_item.quantity.times do
  			LineItem.create cart_id: line_item.cart_id,
  			  product_id: line_item.product_id, quantity: 1
  		end

  		line_item.destroy
  	end
  end
end

