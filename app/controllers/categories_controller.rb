class CategoriesController < ApplicationController

	skip_before_action :authorize
	before_action :admin_user, only:[:index, :new, :create, :edit, :update, :destroy]
    
    layout "admin_layout", only:[:index, :new, :create, :edit, :update, :destroy]

	def index
		@categories = Category.all
	end

	def new
		@category = Category.new
	end
	def create
		@category = Category.new(category_params)

		respond_to do |format|
			if @category.save
				format.html { redirect_to admin_categories_path, notice: '追加されました'}
				format.json { render :index, status: :created, location: @category }
			else
				format.html { render :new }
				format.json { render json: @category.errors, status: :unprocessable_entity }
			end
		end		
	end
	def show
		@rank = Product.joins(:line_items).group(:id).order('SUM(line_items.quantity) DESC').limit(5)
	    @categories = Category.all
		@category = Category.find_by(id: params[:id])
		@cart = current_cart		
 	 	@c_show = @category.products.paginate(page: params[:page], per_page: 12)
        @user = current_user

	end
	def edit
		@category = Category.find_by(id: params[:id])
	end
	def update

		@category = Category.find_by(id: params[:id])

	    respond_to do |format|
	      if @category.update(category_params)
	        format.html { redirect_to admin_categories_path, notice: 'カテゴリー更新しました.' }
	        format.json { render :show, status: :ok, location: @category }
	      else
	        format.html { render :edit }
	        format.json { render json: @category.errors, status: :unprocessable_entity }
	      end
	    end
    end
    def destroy
    	@category = Category.find_by(id: params[:id])

	    @category.destroy
	    respond_to do |format|
	      format.html { redirect_to admin_categories_path, notice: 'カテゴリー削除しました.' }
	      format.json { head :no_content }
	    end
    end

	 private

    def category_params
      params.require(:category).permit(:product_id, :product, :c_name)
    end
    def admin_user
      redirect_to(store_path) unless current_user.admin?
    end
end
