class Dashboard::CouponCodesController < ApplicationController

  def new
    @coupon = CouponCode.new
  end

end
