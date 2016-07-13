object @profile
attributes :id, :state, :uuid, :score, :full_name, :last_name, :first_name, :current_position, :short_summary, :title, :skills

node false do |profile|
  child profile.educations, :root => "educations", :object_root => false do |edu|
    node false do |edu|
      partial("api/educations/education_details", :object => edu)
    end
  end

  child profile.experiences, :root => "experiences", :object_root => false do |exp|
    node false do |exp|
      partial("api/experiences/experience_details", :object => exp)
    end
  end
end