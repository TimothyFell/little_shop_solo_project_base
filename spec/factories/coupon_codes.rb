FactoryBot.define do
  factory :coupon_code do
    name { "MyString" }
    code { "MyString" }
    type { 1 }
    value { 1 }
    used { false }
  end
end
