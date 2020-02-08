class OrdersController < ApplicationController
	skip_before_action :authorize, only: [:new, :create]
	before_action :authenticate
  before_action :setup_order_item!, only: [:confirm_order]
  before_action :admin_user, only: [:index, :edit, :update, :destroy]
    
  layout "admin_layout", only:[:index, :edit, :update, :destroy]


  def new
    @user = current_user
    @rank = Product.joins(:line_items).group(:id).order('SUM(line_items.quantity) DESC').limit(5)
    # @user = current_user
    @categories = Category.all
  	@cart = current_cart
  	if @cart.line_items.empty?
  		redirect_to store_url, notice: "カートは空です"
  		return
  	end

  	@order = Order.new

  	respond_to do |format|
  		format.html
  		format.json { render json: @order }
    end
  end

  def create
  	# @order = Order.new(params[:order])
  	@order = params[:order].permit(:name, :address, :email, :pay_type,:user_id)
  	@example = Order.new(@order)
  	@example.add_line_items_from_cart(current_cart)

    # @user = current_user

  	respond_to do |format|
  		if @example.save
  			Cart.destroy(session[:cart_id])
  			session[:cart_id] = nil
  			OrderNotifierMailer.received(@example).deliver
  			# binding.pry
  			format.html {redirect_to store_url, notice: 
  				'ご注文ありがとうございます＾＾'}
  			format.json { render json: @order, status: :created, location: @order}
  		else
  			@cart = current_cart
  			format.html {render action: "new"}
  			@order = @example
  			format.json {render json: @order.errors,
  				status: :unprocessable_entity}
  		end
  	end
  end

  def index
    # @orders = Order.paginate :page=>params[:page], :order=>'created_at desc',
    # :per_page => 10
    # @orders = Order.page(params[:page], :per_page => 10)
    # @orders = Order.paginate(:page => params[:page], :per_page => 10)
    # Order = created_at: :desc
    # @order = Order.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @orders }
    end

    
  #   if params[:name].present?
  #   @orders = @orders.get_by_name params[:name]
  #   end
  #   if params[:name].present?
  #   @orders = @orders.get_by_name params[:name]
  # elsif params[:address].present?
  #   @orders = @order.get_by_address params[:address]      
  #   end
    # t = Order.arel_table
    # address = params[:address]
    # name = params[:name]
    # @orders = @orders.where(t[:name].matches("%#{name}%")) if name.present?
    # @orders = @orders.where(t[:address].matches("%#{address}%")) if address.present?


      if params[:q]
        relation = Order.joins(:user)
        @orders = relation.merge(User.search_by_keyword(params[:q]))
                        .or(relation.search_by_keyword(params[:q]))
                        .paginate(page: params[:page])
      else
        @orders = Order.paginate(:page => params[:page], :per_page => 10)
      end
    


  end

  def show
    @rank = Product.joins(:line_items).group(:id).order('SUM(line_items.quantity) DESC').limit(5)
    @categories = Category.all
    @user = current_user
    @cart = current_cart
    # @users = @user.products.paginate(page: params[:page], per_page: 9)
    @orders = @user.orders.paginate(page: params[:page], per_page: 10)
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @order }
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :ok }
    end
  end

  private

  def setup_order_item!
    @order_item = current_order.order_items.find_by(product_id: params[:product_id])
  end
  def admin_user
    redirect_to(store_path) unless current_user.admin?
  end
end
