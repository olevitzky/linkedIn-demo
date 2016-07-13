require 'open-uri'

describe "ProfileParser" do
  describe "when the username is valid and exists on Linkedin" do
    let(:username) { 'abdullakhatib' }
    let(:profile) {
      VCR.use_cassette("linkedin-profile-full") do
        pr = build(:profile, :draft, :uuid => username)
        ProfileParser.parse_linkedin_profile(pr)
        pr.reload
      end
    }
    
    context "when all the data is valid and can be parsed" do 
      it "should store all the basic details successfully" do
        profile.first_name.should eq("Abdulla")
        profile.last_name.should eq("Khatib")
        profile.full_name.should eq("#{profile.first_name} #{profile.last_name}")
        profile.title.should include("Taipei Economic & Cultural Office")
        profile.summary.should include("acquiring more skills")
        profile.uuid.should eq(username)
      end

      it "should store the user education data" do
        profile.educations.size.should eq(2)
        education = profile.educations.reorder("created_at ASC").first
        education.name.should eq("University of Toronto")
        education.first_year.should eq(2011)
        education.final_year.should eq(2015)
      end

      it "should store the user experiences" do
        profile.experiences.size.should eq(6)
        exp = profile.experiences.reorder("created_at ASC").last
        exp.company.should eq("Best Buy")
        exp.title.should eq("Computer Specialist")
        exp.start_date.year.should eq(2009)
        exp.end_date.year.should eq(2011)
      end

      it "should store the user skills" do
        profile.skills.should include('Legal Research', 'Government')
      end
    end

    context "when some data is missing" do
      let(:username) { 'empty-profile-94497215' }
      let(:profile) {
        VCR.use_cassette("linkedin-profile-empty") do
          pr = build(:profile, :draft, :uuid => username)
          ProfileParser.parse_linkedin_profile(pr)
          pr.reload
        end
      }

      context "when there are no skills" do
        it "should successfully save a new user with empty skills" do
          profile.uuid.should eq(username)
          profile.skills.should eq([])
        end
      end

      context "when there are no experiences" do
        it ("should successfully save a new user without any experiences and with no current position") do
          profile.uuid.should eq(username)
          profile.experiences.size.should eq(0)
          profile.current_position.should be_nil
        end
      end

      context "when there is no education data" do
        it ("should successfully save a new user without any educations data") do
          profile.uuid.should eq(username)
          profile.educations.size.should eq(0)
        end
      end
    end
  end

  context "when the username does not exists" do
    let(:username) { 'not-existing-profile-for-sure' }
    let(:profile) { build(:profile, :draft, :uuid => username) }
    let(:process_result) {
      VCR.use_cassette("linkedin-profile-not-exists") do
        ProfileParser.parse_linkedin_profile(profile)
      end
    }
    it "should return nil without throwing an exception" do
      profile.state.should eq('draft')
      process_result.should be_nil
    end
  end
end