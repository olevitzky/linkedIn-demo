class Education < ActiveRecord::Base
  belongs_to :profile

  def total_years
    if self.first_year.to_i > 0
      final_year = self.final_year.to_i > 0 ? self.final_year : Time.now.year
      final_year - first_year
    else
      0
    end
  end
end
