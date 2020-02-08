class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authorize

  helper_method :current_user, :logged_in?

  private

  def authorize
    unless User.find_by_id(session[:user_id])
      redirect_to login_url, notice: "ログインしてください"
    end
  end

  def authenticate
      return if logged_in?
      redirect_to login_url, alert: 'ログインしてください'
  end

  def current_cart
    if session[:cart_id]
      @cart = Cart.find(session[:cart_id])
    else
      @cart = Cart.create
      session[:cart_id] = @cart.id
      @cart
    end
  end

  def current_user
      return unless session[:user_id]
      @current_user ||= User.find session[:user_id]
  end

  def logged_in?
      !!session[:user_id]
  end
  def favorited_by? user
    favorites.where(user_id: user.id).exists?
    
  end



end
	