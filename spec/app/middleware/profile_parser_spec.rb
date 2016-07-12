# describe "ProfileParser" do
#   describe "when the username is valid and exists on Linkedin" do
#     before(:all) {
#       @file = File.read("#{File.absolute_path(File.dirname(__FILE__) + '/../../fixtures/abdullakhatib.html')}")
#       ProfileParser.any_instance.stubs(:open_html).returns(@file)
#     }
#     # after(:all) {
#     #   ProfileParser.any_instance.unstub(:open_html)
#     # }

#     let(:username) { 'username_to_test' }
#     let(:profile) { ProfileParser.parse_linkedin_profile(username) }
    
#     context "when all the data is valid and can be parsed" do 
#       it "should store all the basic details successfully" do
#         profile.first_name.should eq("Abdulla")
#         # profile.last_name.should eq(@mock_profile.last_name)
#         # profile.full_name.should eq(@mock_profile.name)
#         # profile.title.should eq(@mock_profile.title)
#         # profile.summary.should eq(@mock_profile.summary)
#         # profile.country.should eq(@mock_profile.country)
#       end

#       it "should have a uuid and prevent another record with same uuid to be created" do
#         profile.uuid.should eq(username)
#         ProfileParser.parse_linkedin_profile(username).should be_nil
#       end

#       # it "should store the user education data" do
#       #   profile.educations.size.should eq(@mock_profile.education.size)
#       #   education = profile.educations.first
#       #   mock_edu = @mock_profile.education.first
#       #   education.name.should eq(mock_edu.name)
#       #   education.first_year.should eq(mock_edu[:start_date].to_i)
#       #   education.final_year.should eq(mock_edu[:end_date].to_i)
#       # end

#       # it "should store the user experiences" do
#       #   mock_experiences = @mock_profile.current_companies + @mock_profile.past_companies
#       #   profile.experiences.size.should eq(mock_experiences.size)
#       #   exp = profile.experiences.order("created_at ASC").last
#       #   mock_exp = mock_experiences.last
#       #   exp.company.should eq(mock_exp[:company])
#       #   exp.title.should eq(mock_exp[:title])
#       #   exp.start_date.should eq(mock_exp[:start_date])

#       #   if mock_exp[:end_date].is_a?(Date)
#       #     exp.end_date.should_not be_nil
#       #   end
#       # end

#       # it "should store the user skills" do
#       # end
#     end

#     # context "when some data is missing" do
#     #   context "when there are no skills" do
#     #     before(:each) {
#     #       Linkedin::Profile.any_instance.stubs(:skills).returns([])
#     #     }
#     #     after(:each) {
#     #       Linkedin::Profile.any_instance.unstub(:skills)
#     #     }

#     #     it "should successfully save a new user with empty skills" do
#     #       profile.uuid.should_not be_nil
#     #       profile.skills.should eq([])
#     #     end
#     #   end

#     #   context "when there are no experiences" do
#     #     before(:each) {
#     #       Linkedin::Profile.any_instance.stubs(:current_companies).returns([])
#     #       Linkedin::Profile.any_instance.stubs(:past_companies).returns([])
#     #     }
#     #     after(:each) {
#     #       Linkedin::Profile.any_instance.unstub(:current_companies)
#     #       Linkedin::Profile.any_instance.unstub(:past_companies)
#     #     }

#     #     it ("should successfully save a new user without any experiences and with no current position") do
#     #       profile.uuid.should_not be_nil
#     #       profile.experiences.size.should eq(0)
#     #       profile.current_position.should be_nil
#     #     end
#     #   end

#     #   context "when there is no education data" do
#     #     before(:each) {
#     #       Linkedin::Profile.any_instance.stubs(:education).returns([])
#     #     }
#     #     after(:each) {
#     #       Linkedin::Profile.any_instance.unstub(:education)
#     #     }

#     #     it ("should successfully save a new user without any educations data") do
#     #       profile.uuid.should_not be_nil
#     #       profile.educations.size.should eq(0)
#     #     end
#     #   end
#     # end


#     # context "when there was an error during the parsing process" do
#     #   before(:each) {
#     #     Linkedin::Profile.any_instance.stubs(:education).returns(nil)
#     #   }
#     #   after(:each) {
#     #     Linkedin::Profile.any_instance.unstub(:education)
#     #   }

#     #   it "should abort the new profile transaction and not add any record" do

#     #   end
#     # end
#   end

#   # context "when the username does not exists" do
#   #   it "should return nil without throwing an exception" do
#   #   end
#   # end
# end