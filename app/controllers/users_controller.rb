class UsersController < ApplicationController

  skip_before_action :authorize, only:[:create, :new]
  before_action :current_user, only:[:edit, :update, :destroy]
  # before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  # before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:index, :edit, :update, :destroy]

  def index
    @categories = Category.all
  	@users = User.order(:name)

  	respond_to do |format|
  		format.html
  		format.json {render json: @users }
  	end
  end
  def new
    @rank = Product.joins(:line_items).group(:id).order('SUM(line_items.quantity) DESC').limit(5)
    @cart = current_cart
    @categories = Category.all
  	@user = User.new	
  end
  def create
  	@user = User.new(params.require(:user).permit(:name,:email, :password, :password_digest))
  
  	respond_to do |format|
  		if @user.save
  			format.html { redirect_to login_url,
  				notice: "ユーザ#{@user.name}を作成しました。"}
  			format.json { render json: @user,
  			    status: :created, location: @user }
  		else
  			format.html { render action: "new"}
  			format.json { render json: @user.errors,
  				  status: :unprocessable_entity }
  		end
  	end
  end
  def show
    @rank = Product.joins(:line_items).group(:id).order('SUM(line_items.quantity) DESC').limit(5)
    @categories = Category.all
  	@user = User.find(params[:id])
    @cart = current_cart
    @users = @user.products.paginate(page: params[:page], per_page: 9)
    @orders = @user.orders.paginate(page: params[:page], per_page: 10)

  end
  def edit
    @rank = Product.joins(:line_items).group(:id).order('SUM(line_items.quantity) DESC').limit(5)
    @cart = current_cart
    @categories = Category.all
  	@user = User.find(params[:id])
  	
  end
  def update
  	@user = User.find(params[:id])

  	respond_to do |format|
  		if @user.update_attributes(params.require(:user).permit(:name,:email, :password, :password_digest))
  			format.html { redirect_to user_url,
  				notice:"ユーザー#{@user.name}を更新しました。"}
  			format.json {head :ok}
  		else
  			format.html { render action: "edit" }
  			format.json { render json: @user.errors,
  				status: :unprocessable_entity }
  		end
  	end
  end
  def destroy
  	@user = User.find(params[:id])
  	begin
  		@user.destroy
  		flash[:notice] = "ユーザー#{@user.name}を削除しました。"
  	rescue Exception => e
  		flash[:notice] = e.message
  	end

    respond_to do |format|
      format.html { redirect_to store_url }
      format.json { head :ok }
    end
  end

  def favorites
  	@user = User.find(params[:id])
  	
  end

  private

    def admin_user
      redirect_to(store_path) unless current_user.admin?
    end





end
