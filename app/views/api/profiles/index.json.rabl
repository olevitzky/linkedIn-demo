object false

node :total do
  @profiles.try(:size)
end

child @profiles, :root => "profiles", :object_root => false do |profile|
  node false do |profile|
    partial("api/profiles/profile_details", :object => profile)
  end
end