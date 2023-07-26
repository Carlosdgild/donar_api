class Donation < ApplicationRecord
  acts_as_paranoid
  # associations
  belongs_to :user
  belongs_to :payment, optional: true
  belongs_to :login_activity
  # concerns
  include PaymentStatusable
  # Validations
  validates :amount, numericality: { greater_than: 0 }

  def self.filter_by_date(start_date, end_date, field = 'created_at')
    result = where(nil).preload(:payment)
    if start_date.present?
      start_date = Time.zone.parse start_date
      result = result.where(
        "#{table_name}.#{field} >= ?", start_date.beginning_of_day
      )
    end
    if end_date.present?
      end_date = Time.zone.parse end_date
      result = result.where "#{table_name}.#{field} <= ?", end_date.end_of_day
    end
    result
  end
end
