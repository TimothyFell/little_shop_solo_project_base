FactoryBot.define do
  factory :coupon_code do
    code { "MyString" }
    coupon_type { 'percentage' }
    value { 15 }
    minimum_order { 20}
  end
end
