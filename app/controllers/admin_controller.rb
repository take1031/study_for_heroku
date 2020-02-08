class AdminController < ApplicationController
  
  layout "admin_layout"
  before_action :admin_user

  def index
  	@total_orders = Order.count
  	@total_products = Product.count
  	@total_users = User.count
  	@total_categories = Category.count

    # @products = Product.all

    # @products = Product.joins(:line_items).includes(:line_items).order("line_items.to_a.sum { |item| item.quantity} desc")


    # @products = Product.total_count.order("quantity DESC")
    # @rank = @products.total_count('desc').limit(5)
  end

  def products
  	@products = Product.all
    # Product.joins(:line_items).group(:id).order('SUM(line_items.quantity) DESC').limit(3)

    # @products = Product.all.joins(:line_items).includes(:line_items).order("total_count desc")

  	# @product = Product.find_by(id: params[:id])
    # @total_product = @products.line_items.sum(:quantity)
	  if params[:title].present?
      @products = @products.get_by_name params[:title]
    end
  end
  def users
  	@users = User.all

    if params[:title].present?
      @users = @users.get_by_name params[:name]
    end
  end
  def categories
  	# @categories = Category.new
  	@categories = Category.all
    @category = Category.new


  	# respond_to do |format|
  	# 	if @category.save
  	# 		format.html {redirect_to admin_categories_path, notice:'追加されました'}
  	# # 	else
  	# # 		# format.html {redirect_to admin_categories_path, notice:'追加できませんでした'}
  	# 	end
  	# end
  end
  def add_category
  	@category = Category.new(category_params)
  	
  	respond_to do |format|
      if @category.save
        format.html { redirect_to admin_categories_path, notice: '' }
      else
        format.html { render :add_category, notice: '追加できませんでした' }

      end
    end
  	
  end
  def orders
  	@orders = Order.all  	
  end
    private

    def admin_user
      redirect_to(store_path) unless current_user.admin?
    end
end
