class Merchant::DiscountsController < Merchant::BaseController

  def index
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def new

  end

  def create
    merchant = current_user.merchant
    @discount = merchant.discounts.new(discount_params)
    if @discount.save
      redirect_to '/merchant/discounts'
      flash[:success] = "Your new discount has been added"
    else
      flash[:notice] = "Please fill out all 3 fields"
      redirect_to '/merchant/discounts/new'
    end
  end



  private
  def discount_params
    params.permit(:discount_percentage, :minimum_quantity, :description)
  end

end
