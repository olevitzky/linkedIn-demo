# This class takes a LinkedIn url (or LinkedIn username), and parses the page if such exists.
# Here I use a ruby gem called 'linkedin-scraper' to get the profile data and saves what we need into the database.
class ProfileParserGem
  BASE_LINKED_IN_URL = "https://www.linkedin.com/in/"

  # Returns true if the given username was parsed successfully
  def self.parse_linkedin_profile(username)
    parser = ProfileParserGem.new(username)
    parser.parse!
  rescue Exception => e
    puts "parse_linkedin_profile Exception: #{e}"
    return nil
  end

  def initialize(username)
    @profile_url = "#{BASE_LINKED_IN_URL}#{username}"
    @linkedin_profile = Linkedin::Profile.new(@profile_url, { company_details: true })
    @profile = Profile.new
    @profile.uuid = username
  end

  def parse!
    ActiveRecord::Base.transaction do
      parse_basic_details
      parse_skills
      parse_educations
      parse_experiences
      @profile.save!
    end
    
    @profile
  rescue Exception => e
    puts "parse! Exception: #{e}"
    return nil
  end

  # Store the profile basics such as name, current position, current title and summary
  def parse_basic_details
    puts "###### Saving basic details ######"
    @profile.first_name = @linkedin_profile.first_name
    @profile.last_name = @linkedin_profile.last_name
    @profile.full_name = @linkedin_profile.name
    @profile.title = @linkedin_profile.title
    @profile.summary = @linkedin_profile.summary
    @profile.country = @linkedin_profile.country
    @profile.save!
  end

  def parse_skills
    puts "###### Saving skills ######"
    @profile.skills = @linkedin_profile.skills
  end

  def parse_educations
    puts "###### Saving education ######"
    education_array = @linkedin_profile.education
    education_array.each do |edu_data|
      profile_education = @profile.educations.new
      profile_education.name = edu_data[:name]
      profile_education.first_year = edu_data[:start_date].to_i > 0 ? edu_data[:start_date].to_i : nil
      profile_education.final_year = edu_data[:end_date].to_i > 0 ? edu_data[:end_date].to_i : nil
      # calculate total years on the model after create
    end
  end

  def parse_experiences
    puts "###### Saving experiences ######"
    current_companies_array = @linkedin_profile.current_companies
    if current_companies_array.present?
      @profile.current_position = current_companies_array.first[:company]
    end
    past_companies_array = @linkedin_profile.past_companies
    companies_array = current_companies_array + past_companies_array
    companies_array.each do |comp_data|
      profile_experience = @profile.experiences.new
      profile_experience.company = comp_data[:company]
      profile_experience.title = comp_data[:title]
      profile_experience.start_date = comp_data[:start_date]
      profile_experience.end_date = comp_data[:end_date].is_a?(Date) ? comp_data[:end_date] : nil
      # calculate the total years on after create
    end
  end

end