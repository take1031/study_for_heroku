class ProductsController < ApplicationController
  # before_action :set_product, only: [:show, :edit, :update, :destroy, :pay]
  # before_action :authenticate_user!
  layout "admin_layout", only:[:index, :new, :create, :edit, :update, :destroy]

  before_action :admin_user, only:[:index, :new, :create, :edit, :update, :destroy]
  def index
    @categories = Category.all
  	@products = Product.all

  	if params[:title].present?
  	@products = @products.get_by_name params[:title]
    end
  end
  def new
    # render :layout => "admin_layout"
  	@product = Product.new
    @categories = Category.all
  end
  def create
    # render :layout => 'admin_layout'
  	@product = Product.new(product_params)
  	
  	respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end
  def show
    @rank = Product.joins(:line_items).group(:id).order('SUM(line_items.quantity) DESC').limit(5)
    @categories = Category.all
  	@product = Product.find_by(id: params[:id])
    
  	@cart = current_cart
  	@user = current_user
  end
  def edit
  	@product = Product.find_by(id: params[:id])
  end
  def update

    @product = Product.find_by(id: params[:id])

    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end
  def destroy

  	@product = Product.find_by(id: params[:id])

    @product.destroy
    respond_to do |format|
      format.html { redirect_to admin_products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def who_bought
  	@product = Product.find(params[:id])
  	respond_to do |format|
  		format.atom
  	end
  end



  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:title, :description, :image_url, :price, :category_id, :c_name)
    end

    def admin_user
      redirect_to(store_path) unless current_user.admin?
    end
end
