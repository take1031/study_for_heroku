class LineItemsController < ApplicationController
  skip_before_action :authorize, only: :create
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only:[:index]

  layout "admin_layout", only:[:index]

  def index
    @line_items = LineItem.all
  end

  def show
  	@line_item = LineItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @line_item }
    end
  end

  def new
    @line_item = LineItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @line_item }
    end
  end

  def edit
  	@line_item = LineItem.find(params[:id])
  end

  def create
  	@cart = current_cart
  	product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product.id)

    respond_to do |format|
      if @line_item.save(validate: false)
        # format.html { redirect_to store_url, notice: 'Line item was successfully created.' }
        format.html { redirect_to store_url}
        format.js { @current_item = @line_item}
        format.json { render json: @line_item, status: :created, location: @line_item }
      else
        format.html { render action: "new" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  	@line_item = LineItem.find(params[:id])

    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  	@line_item = LineItem.find(params[:id])
    @line_item.destroy
    respond_to do |format|
      format.html { redirect_to store_url, notice: 'Line item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def decrease
  	@cart = current_cart
  	@line_item = @cart.decrease(params[:id])

  	respond_to do |format|
  		if @line_item.save(validate: false)
  			format.html{redirect_to store_url}
        format.js { @current_item = @line_item}
  			format.json{head :ok}
  		else
  			format.html{render action: "edit"}
  			format.json{render json: @line_item.errors, status: :unprocessable_entity}
  		end
  	end
  end

  def increase
  	@cart = current_cart
  	@line_item = @cart.increase(params[:id])

  	respond_to do |format|
  		if @line_item.save(validate: false)
  			format.html{redirect_to store_url}
        format.js { @current_item = @line_item}
  			format.json{head :ok}
  		else
  			format.html{render action: "edit"}
  			format.json{render json: @line_item.errors, status: :unprocessable_entity}
  		end
  	end
  end

  private
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    def line_item_params
      params.fetch(:line_item, {})
    end
    def admin_user
      redirect_to(store_path) unless current_user.admin?
    end
end
