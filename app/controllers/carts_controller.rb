class CartsController < ApplicationController
  # before_action :set_cart, only: [:show, :edit, :update, :destroy]
  skip_before_action :authorize, only: [:create, :update, :destroy]
  before_action :admin_user, only: [:index,:show]
  def index
    @user = current_user
    @categories = Category.all
    @carts = Cart.all
    @rank = Product.joins(:line_items).group(:id).order('SUM(line_items.quantity) DESC').limit(5)


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @carts }
    end
  end

  def show
  	begin
  		@cart = Cart.find(params[:id])
  	rescue ActiveRecord::RecordNotFound
  		logger.error "無効なカート#{params[:id]}にアクセスしようとしました"
  		redirect_to store_url, notice: '無効なカートです'
  	else
  		respond_to do |format|
  			format.html #show.html.erb
  			format.json { render json: @cart }
  		end
  	end
  end

  def new
    @cart = Cart.new
    @categories = Category.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cart }
    end
  end

  def edit
    @cart = Cart.find(params[:id])

  end

  def create
    @cart = Cart.new(params[:cart])

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: 'Cart was successfully created.' }
        format.json { render json: @cart, status: :created, location: @cart }
      else
        format.html { render :new }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  	@cart = Cart.find(params[:id])

    respond_to do |format|
      if @cart.update_attributes(params[:cart])
        format.html { redirect_to @cart, notice: 'Cart was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :edit }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  	@cart = current_cart
    @cart.destroy
    session[:cart_id] = nil
    respond_to do |format|
      format.html { redirect_to store_url }
      format.json { head :ok }
    end
  end

  # private

  #   def set_cart
  #     @cart = Cart.find(params[:id])
  #   end

  #   def cart_params
  #     params.fetch(:cart, {})
  #   end
    private

    def admin_user
      redirect_to(store_path) unless current_user.admin?
    end
end
