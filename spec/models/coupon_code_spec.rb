require 'rails_helper'

RSpec.describe CouponCode, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:coupon_type) }
    it { should validate_presence_of(:minimum_order) }
    it { should validate_presence_of(:value) }
    it { should validate_numericality_of(:value) }
    it { should validate_presence_of(:code) }
    it { should validate_uniqueness_of(:code) }
  end
end
