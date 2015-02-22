class CoursePurchase < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with CoursePurchaseValidator
  validates_uniqueness_of :publish_record_id, scope: :user_id

  belongs_to :user
  belongs_to :publish_record

  has_one :course
  has_many :purchase_records, order: 'created_at DESC'

  def capacity
    student_count = 0
    if self.course
      student_count = self.course.student_courses.count
    end

    self.purchase_records.map{ |purchase_record|
      (purchase_record.is_paid?) ? purchase_record.seat_count : 0
    }.sum - self.seat_taken_count + student_count
  end

  def vacancy
    self.capacity - self.course.student_courses.count
  end

  def has_unclaimed_purchases?
    unclaimed_purchases_amount > 0
  end

  def seats_purchased
    self.seats_purchased_between(Time.new(0), Time.now)
  end

  def seats_purchased_between(start_date, end_date)
    self.purchase_records
      .where('created_at between ? and ?', start_date, end_date)
      .map { |purchase_record| purchase_record.seat_count }.sum
  end

  def unclaimed_purchases_amount
    self.unclaimed_purchases_amount_between(Time.new(0), Time.now)
  end

  def unclaimed_purchases_amount_between(start_date, end_date)
    self.all_purchases_amount_between(start_date, end_date) *
        I18n.t('number.payout_proportion').to_f -
        self.claimed_purchases_amount_between(start_date, end_date)
  end

  def claimed_purchases_amount
    self.unclaimed_purchases_amount_between(Time.new(0), Time.now)
  end

  def claimed_purchases_amount_between(start_date, end_date)
    self.purchase_records
      .where('created_at between ? and ?', start_date, end_date)
      .map { |purchase_record|
        (purchase_record.payout_transaction and purchase_record.payout_transaction.is_paid?) ?
            purchase_record.payout_amount : 0
      }.sum
  end

  def all_purchases_amount
    self.all_purchases_amount_between(Time.new(0), Time.now)
  end

  def all_purchases_amount_between(start_date, end_date)
    self.purchase_records
      .where('created_at between ? and ?', start_date, end_date)
      .map { |purchase_record|
        purchase_record.price_per_seat * purchase_record.seat_count
      }.sum
  end
end
