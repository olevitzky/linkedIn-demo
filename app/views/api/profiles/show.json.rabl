object @profile

node false do |profile|
  partial("api/profiles/profile_details", :object => profile)
end