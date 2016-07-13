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
    state 'completed'

    trait :draft do
      uuid "orenL"
      state 'draft'
      first_name nil
      last_name nil
      full_name nil
      title nil
      current_position nil
      summary nil
      skills nil
    end
  end
end