class Dashboard::ProductsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_product, only: %w[show edit update destroy ]
  layout "dashboard/dashboard"

  def index
    logger.debug("--------------------------------------------- index start")
    sort_query = []
    @sorted = ""

    if params[:sort].present?
      slices = split(' ', params[:sort])
      sort_query[slices[0]] = slices[1]
      @sorted = params[:sort]
    end

    if params[:keyword] != nil
      keyword = trim(params[:keyword])
      @total_count = Product.search_for_id_and_name(keyword).count
      @products = Product.search_for_id_and_name(keyword).sort_order(sort_query).display_list(params[:pages])
    else
      keyword = ""
      @total_count = Product.count
      @products = Product.display_list(params[:page])
    end
    
    @sort_list = Product.sort_list
    logger.debug("--------------------------------------------- index end")
    # redirect_to dashboard_products_path
    @product = Product.new(params[:recommend_flag])
  end

  def new
    @categories = Category.all
    @product = Product.new(params[:recommend_flag])
  end

  def create
    product = Product.new(params[:recommend_flag])
    product.save
    redirect_to dashboard_products_path
  end

  def edit
    @categories = Category.all
  end

  def update
    @product.update(product_params)
    redirect_to dashboard_products_path
  end

  def destroy
    @product.destroy
    redirect_to dashboard_products_path
  end
  
  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description, :price, :recommend_flag, :carriage_flag, :category_id, :image)
    end
    
  
end
