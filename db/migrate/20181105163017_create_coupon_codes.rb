class CreateCouponCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :coupon_codes do |t|
      t.integer :coupon_type
      t.float :value
      t.string :code
      t.float :minimum_order, default:0
      t.references :user, foreign_key: true
    end
  end
end
