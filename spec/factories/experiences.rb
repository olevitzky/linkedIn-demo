FactoryGirl.define do
  factory :experience do
    company "Gartner"
    title "Developer"
    start_date (Time.now - 4.years).to_date
    end_date Time.now.to_date
  end
end