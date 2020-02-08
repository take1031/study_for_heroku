class SessionsController < ApplicationController
	skip_before_action :authorize

  def new
    # unless session[:cart_id].nil?
    #   cart.line_items = Cart.find_by(id: session[:cart_id]).line_items
    # end

    @cart = current_cart
    @categories = Category.all
    @rank = Product.joins(:line_items).group(:id).order('SUM(line_items.quantity) DESC').limit(5)
  end

  def create
  	user = User.find_by_name(params[:name])

  	if user and user.authenticate(params[:password])
  		session[:user_id] = user.id
      if user.admin
        redirect_to admin_url
      else      
  		  redirect_to store_url
      end       
  	else
  		redirect_to login_url, alert: "無効なユーザー/ パスワードの組み合わせです"
  	end
  end

  def destroy
  	session[:user_id] = nil
    Cart.find_by(id: session[:cart_id]).destroy
    session[:cart_id] = nil   
  	redirect_to store_index_path, notice: "ログアウト"
  end
end
