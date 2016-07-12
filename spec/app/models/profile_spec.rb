RSpec.describe Profile, type: :model do
  let(:profile) { build(:profile) }

  describe "calculate_score!" do
    context "when the profile has skills only" do
      let(:profile) { 
        pr = build(:profile) 
        pr.educations.delete_all
        pr.experiences.delete_all
        pr
      }

      it "should return a correct score regardless of education and experiences" do
        profile.calculate_score!
        profile.score.should eq(profile.skills.size * Profile::SKILL_SCORE)
      end
    end

    context "when the profile has education data only" do
      let(:profile) { 
        pr = build(:profile, :skills => [])
        pr.educations << build(:education)
        pr.experiences.delete_all
        pr
      }

      it "should return the correct score only by the education points" do
        profile.calculate_score!
        profile.score.should eq(profile.educations.inject(0) {|sum, ed| sum + ed.score})
      end
    end

    context "when the profile has experiences data only" do
      let(:profile) { 
        pr = build(:profile, :skills => [])
        pr.experiences << build(:experience)
        pr.educations.delete_all
        pr
      }

      it "should return the correct score only by the experiences points" do
        profile.calculate_score!
        profile.score.should eq(profile.experiences.inject(0) {|sum, exp| sum + exp.score})
      end
    end

    context "when the profile has no scoring data" do
      let(:profile) { 
        pr = build(:profile, :skills => [])
        pr.educations.delete_all
        pr.experiences.delete_all
        pr
      }
      it "should result in score 0" do
        profile.calculate_score!
        profile.score.should eq(0)
      end
    end
  end
end