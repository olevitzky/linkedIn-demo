class Experience < ActiveRecord::Base
  belongs_to :profile

  def duration_in_months
    if self.start_date.present?
      end_date = self.end_date.present? ? self.end_date : DateTime.now.to_date
      (end_date.to_time - self.start_date.to_time) / 1.month
    else
      0
    end
  rescue
    0
  end
end
