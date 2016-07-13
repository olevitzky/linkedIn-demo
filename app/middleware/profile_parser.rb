# This class takes a LinkedIn url (or LinkedIn username), and parses the page if such exists.
# Here I use a ruby gem called 'linkedin-scraper' to get the profile data and saves what we need into the database.
require 'open-uri'

class ProfileParser
  BASE_LINKED_IN_URL = "https://www.linkedin.com/in/"

  # Returns true if the given username was parsed successfully
  def self.parse_linkedin_profile(profile)
    parser = ProfileParser.new(profile)
    parser.parse!
  rescue Exception => e
    puts "parse_linkedin_profile Exception: #{e}"
    return nil
  end

  def initialize(profile)
    @profile = profile
    @doc = Nokogiri::HTML(open("#{BASE_LINKED_IN_URL}#{@profile.uuid}"))
  end

  def parse!
    ActiveRecord::Base.transaction do
      parse_basic_details
      parse_summary
      parse_skills
      parse_educations
      parse_experiences
      @profile.save!
      @profile.calculate_score!
    end
    
    true    
  rescue Exception => e
    puts "parse! Exception: #{e}"
    return nil
  end

  def parse_basic_details
    overview = @doc.css(".profile-overview-content")[0]
    name_node = overview.css("#name").first.try(:text)
    full_name_array = name_node.present? ? name_node.split(" ") : []
    @profile.full_name = full_name_array.join(" ")
    @profile.first_name = full_name_array.first
    @profile.last_name = full_name_array[1..-1].try(:join, " ")
    @profile.title = overview.css("[data-section=headline]").first.try(:text)
    current_position_node = overview.css("[data-section=currentPositionsDetails] .org").first
    if current_position_node.present?
      @profile.current_position = current_position_node.text
    end

    # creating the user for the first time. Validating the basic data with uuid and continuing only if all is good
    @profile.save!
  end

  def parse_summary
    @profile.summary = @doc.css("section[data-section=summary] .description").first.try(:text)
  end

  def parse_skills
    skills = []
    @doc.css("section[data-section=skills] ul.pills li").each do |li|
      klasses = li.attribute('class').value
      if (not klasses.include?('see-more')) && (not klasses.include?('see-less'))
        skills << li.text
      end
    end
    @profile.skills = skills
  end

  def parse_educations
    @doc.css("section[data-section=educationsDetails] ul li").each do |li|
      name = li.css(".item-title").first.try(:text)
      # adding new education history only when we have the name of that school
      if name.present?
        profile_education = @profile.educations.new
        profile_education.name = name
        dates = li.css(".date-range time")
        if dates.present?
          start_date = dates.first.text.to_i
          profile_education.first_year = start_date > 0 ? start_date : nil
          if dates[1].present?
            end_date = dates[1].text.to_i
            profile_education.final_year = end_date > 0 ? end_date : nil
          end
        end
      end
    end
  end

  def parse_experiences
    @doc.css("section#experience ul.positions li.position").each do |li|
      title = li.css(".item-title").first.try(:text)
      # adding new experience history only when we have the title of that position
      if title.present?
        profile_experience = @profile.experiences.new
        profile_experience.title = title
        profile_experience.company = li.css(".item-subtitle").first.try(:text)
        
        dates = li.css(".date-range time")
        if dates.present?
          profile_experience.start_date = extract_experience_date(dates.first.text)
          if dates[1].present?
            profile_experience.end_date = extract_experience_date(dates[1].text)
          end
        end
      end
    end
  end

  # Sometimes the experience dates on Linkedin are only the year a sometime it comes with the month.
  # Other formats are not supported thus nil is returned
  def extract_experience_date(date_string)
    if date_string.to_i > 0
      # only year date
      return Date.strptime(date_string, "%Y")
    else
      return Date.strptime(date_string, "%B %Y")
    end
  rescue
  end
end