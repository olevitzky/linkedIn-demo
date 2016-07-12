FactoryGirl.define do
  factory :profile do
    uuid "orenL"
    first_name "Oren"
    last_name "Levitzky"
    full_name "Oren Levitzky"
    title "Senior web developer"
    current_position "Crossrider"
    summary "Love developing"
    skills ['LinkedIn', 'OOD', 'CSS']
  end
end