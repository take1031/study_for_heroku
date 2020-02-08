class StoreController < ApplicationController

	skip_before_action :authorize

	def index
	  	# @products = Product.order(:title)
	  	@cart = current_cart
	  	@categories = Category.all
	  	@user = current_user
	  	# @product = Product.find(product: product])

	  	

	  	@rank = Product.joins(:line_items).group(:id).order('SUM(line_items.quantity) DESC').limit(5)


	  	@products = Product.paginate(:page => params[:page], :per_page => 12)

	  	if params[:title].present?
	  	    @products = @products.get_by_name params[:title]
	    end
	end
end
