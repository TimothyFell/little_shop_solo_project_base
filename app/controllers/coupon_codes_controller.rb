class CouponCodesController < ApplicationController

  def create
    render file: 'errors/not_found', status: 404 unless current_user.id == session[:user_id]

  	if coupon_params[:coupon_type] == 'dollars_off' && coupon_params[:minimum_order].to_f < coupon_params[:value].to_f
      flash[:notice] = 'The discount amount you entered was larger than the minimum order amount. Please make the minimum order amount is larger than the coupon value.'
  		redirect_to new_dashboard_coupon_code_path
    else
      user = User.find(session[:user_id])
  		coupon = user.coupon_codes.create(
        {coupon_type: coupon_params[:coupon_type],
        value: coupon_params[:value],
        minimum_order: coupon_params[:minimum_order],
        code: SecureRandom.uuid}
      )
      redirect_to dashboard_path
  	end
  end

  private

    def coupon_params
      params.require(:coupon_code).permit(:coupon_type, :value, :minimum_order, :code)
    end

end
