class OrderItemsController < ApplicationController
  skip_before_action :authorize, only: :create
  before_action :set_order_item, only: [:show, :edit, :update, :destroy]
  before_action :admin_user
  def index
    @order_items = OrderItem.all
  end

  def show
  end

  # カート詳細画面から、「購入画面に進む」を押した時のアクション
  def confirm_order
    @line_items = LineItem.find(params[:line_item_id])
    @line_items.each do |line_item|
      OrderItem.create(
                      order_id: current_order.id, 
                      product_id: line_item.product_id, 
                      quantity: line_item.quantity
                      )
    end
    redirect_to new_order_path
  end

  # GET /order_items/new
  def new
    @order_item = OrderItem.new
  end

  def edit
  end

  def create
  	@cart = current_cart
    @order_item = OrderItem.new(order_item_params)

    respond_to do |format|
      if @order_item.save
        format.html { redirect_to @order_item, notice: 'Order item was successfully created.' }
        format.json { render :show, status: :created, location: @order_item }
      else
        format.html { render :new }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /order_items/1
  # PATCH/PUT /order_items/1.json
  def update
    respond_to do |format|
      if @order_item.update(order_item_params)
        format.html { redirect_to @order_item, notice: 'Order item was successfully updated.' }
        format.json { render :show, status: :ok, location: @order_item }
      else
        format.html { render :edit }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order_item.destroy
    respond_to do |format|
      format.html { redirect_to order_items_url, notice: 'Order item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_order_item
      @order_item = OrderItem.find(params[:id])
    end
    def order_item_params
      params.fetch(:order_item, {})
    end

    def admin_user
      redirect_to(store_path) unless current_user.admin?
    end
end