class Experience < ActiveRecord::Base
  belongs_to :profile

  EXPERIENCE_MONTH_SCORE = 0.6

  def duration_in_months
    if self.start_date.present?
      end_date = self.end_date.present? ? self.end_date : DateTime.now.to_date
      if start_date > end_date
        raise "Start date can not be greater than end date"
      else
        (end_date.to_time - self.start_date.to_time) / 1.month
      end
    else
      0
    end
  rescue
    0
  end

  def score
    self.duration_in_months * EXPERIENCE_MONTH_SCORE
  end
end
