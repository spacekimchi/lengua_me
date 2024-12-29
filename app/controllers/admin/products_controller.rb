module Admin
  class ProductsController < ApplicationController
    def index
      @products = Product.all
    end

    def show
      @product = Product.find_by(id: params[:id])
    end

    def new
      @product = Product.new
    end

    def create
      @product = Product.new(product_params)
      if @product.save
        redirect_to admin_product_path(@product), notice: t('controllers.admin.products.create.success')
      else
        render :new
      end
    end

    def edit
      @product = Product.find(params[:id])
    end

    def update
      @product = Product.find(params[:id])
      if @product.update(product_params)
        redirect_to [:admin, @product], notice: t('controllers.admin.products.update.success')
      else
        render :edit
      end
    end

    def destroy
      @product = Product.find(params[:id])
      @product.destroy
      redirect_to products_url, notice: t('controllers.admin.products.destroy.success')
    end

    private

    def product_params
      params.require(:product).permit(:name, :description, :stripe_product_id, :lookup_key, :is_active, :for_subscription)
    end
  end
end
