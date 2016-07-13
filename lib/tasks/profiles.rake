task :generate_profiles => :environment do
  puts "Cleaning profiles"
  Profile.all.each {|pr| pr.destroy}
  usernames = ['zack-shamoon-06535366', 'abdullakhatib', 'dantley-tillman-8397942a', 'dantley-chan-298b398b', 'danto-adhityo-26229741', 'danto-adityo-57547989']
  usernames.each do |name|
    profile = Profile.create(:uuid => name)
    if profile.enqueue
      puts "Enqueuing #{name}"
    end
  end
end