module Liff
  class ProductsController < BaseController
    def index
      @products = Product.active.sorted
    end
  end
end
