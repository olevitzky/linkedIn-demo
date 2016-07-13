RSpec.describe Profile, type: :model do
  let(:profile) { build(:profile, :draft) }

  describe "state machine" do
    context "when its a new profile" do
      it "should have the initial state" do
        profile.state.should eq('draft')
      end

      context "when trying to enqueue the profile" do
        it "should be marked as enqueued" do
          profile.enqueue.should be true
        end
      end

      context "when trying to fail the profile job process" do
        it "should be marked as failed" do
          profile.mark_as_failed.should be true
        end
      end

      context "when trying to mark the profile state as completed" do
        it "should not change the state since the transition is not valid and the profile should be enqueued first" do
          profile.complete.should be false
        end
      end
    end

    context "when the profile is enqueued" do
      let(:profile) { build(:profile, :state => 'enqueued') }

      context "when processing" do
        it "should be marked as processing" do
          profile.process.should be true
        end
      end

      context "when trying to mark the profile state as completed" do
        it "should not change the state since the transition is not valid and the profile should be processed first" do
          profile.complete.should be false
        end
      end

      context "when trying to fail the profile job process" do
        it "should be marked as failed" do
          profile.mark_as_failed.should be true
        end
      end
    end

    context "when the profile is processing" do
      let(:profile) { build(:profile, :state => 'processing') }

      context "when the profile processing is ended" do
        it "should be marked as completed" do
          profile.complete.should be true
        end
      end

      context "when trying to fail the profile job process" do
        it "should be marked as failed" do
          profile.mark_as_failed.should be true
        end
      end
    end
  end

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