class PurchaseRecord < ActiveRecord::Base
  # price_per_seat takes a snapshot of the price of the course at
  # the time of purchase so that, later when price changes, this
  # price stays unchanged.
  validates :seat_count, numericality: {greater_than_or_equal_to: 0, greater_than_or_equal_to: :seats_taken}

  attr_accessible :seat_count, :price_per_seat, :course_purchase, :is_paid?

  belongs_to :course_purchase

  def vacancy
    self.seat_count - self.seats_taken
  end

  def has_vacancy?
    self.vacancy > 0
  end
end
