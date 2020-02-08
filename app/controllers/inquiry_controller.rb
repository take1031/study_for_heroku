class InquiryController < ApplicationController

	def index

        @user = current_user
		@rank = Product.joins(:line_items).group(:id).order('SUM(line_items.quantity) DESC').limit(5)
		@categories = Category.all
		@cart = current_cart
	    # 入力画面を表示
	    @inquiry = Inquiry.new
	    render :action => 'index'
	end
	 
	def confirm
		@user = current_user
		@rank = Product.joins(:line_items).group(:id).order('SUM(line_items.quantity) DESC').limit(5)
		@categories = Category.all
		@cart = current_cart
	    # 入力値のチェック
	    @inquiry = Inquiry.new(inquiry_params)
	  if @inquiry.valid?
	      # OK。確認画面を表示
	      render :action => 'confirm'
	  else
	      # NG。入力画面を再表示
	      render :action => 'index'
	  end
	end
	 
	def thanks
		@user = current_user
		@rank = Product.joins(:line_items).group(:id).order('SUM(line_items.quantity) DESC').limit(5)
		@categories = Category.all
		@cart = current_cart
	    # メール送信
	    @inquiry = Inquiry.new(inquiry_params)
	    InquiryMailer.received_email(@inquiry).deliver
	 
	    # 完了画面を表示
	    render :action => 'thanks'
	end

	def inquiry_params
		params.require(:inquiry).permit(:name, :email, :message, :inquiry)
		
	end
end
