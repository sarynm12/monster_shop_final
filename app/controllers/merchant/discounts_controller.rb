class Merchant::DiscountsController < Merchant::BaseController

  def index
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def show
    @discount = Discount.find(params[:discount_id])
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
      flash[:error] = @discount.errors.full_messages.to_sentence
      redirect_to '/merchant/discounts/new'
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    @discount.update(discount_params)
    if @discount.save
      redirect_to '/merchant/discounts'
    else
      flash[:error] = @discount.errors.full_messages.to_sentence
      redirect_to "/merchant/discounts/#{@discount.id}/edit"
    end
  end

  def destroy
    @discount = Discount.find(params[:id])
    @discount.destroy
    flash[:success] = "Discount has been deleted"
    redirect_to "/merchant/discounts"
  end

  private
  def discount_params
    params.permit(:discount_percentage, :minimum_quantity, :description)
  end

end
