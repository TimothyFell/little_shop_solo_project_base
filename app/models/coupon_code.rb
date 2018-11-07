class CouponCode < ApplicationRecord
  belongs_to :user

  validates_presence_of :coupon_type
  validates :value, presence:true, :numericality => { greater_than: 0}
  validates :minimum_order, presence:true
  validates :code, presence:true, uniqueness:true

  enum coupon_type: %w( percentage dollars_off)
end
