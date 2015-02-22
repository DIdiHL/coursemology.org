class PublishRecord < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with PublishRecordValidator
  validates_uniqueness_of :course_id
  validates :price_per_seat, numericality: {greater_than_or_equal_to: 0}
  validates :published, inclusion: {in: [true, false]}

  attr_accessible :price_per_seat, :published, :course_id

  belongs_to :course
  has_many :course_purchases

  def free?
    self.price_per_seat == 0
  end

  def payout_identity
    result = nil
    if self.course
      result = self.course.creator.payout_identity
    end
    result
  end

  def has_sales_between?(start_date, end_date)
    self.course_purchases.each do |course_purchase|
      if course_purchase.purchase_records.where('created_at between ? and ?', start_date, end_date).count > 0
        return true
      end
    end
    false
  end
end
