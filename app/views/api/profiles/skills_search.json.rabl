object false

node :total_results do
  @profiles.try(:total_entries).to_i
end

node :pagination do
  {:current_page => @page, :total_pages => @profiles.try(:total_pages).to_i}
end

child @profiles, :root => "profiles", :object_root => false do |profile|
  node false do |profile|
    partial("api/profiles/profile_details", :object => profile)
  end
end