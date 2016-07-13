RSpec.describe Experience, type: :model do
  let(:start_date) { (Time.now - 4.years).to_date }
  let(:end_date) { Time.now.to_date }
  let(:experience) { build_stubbed(:experience, :start_date => start_date, :end_date => end_date) }

  describe "duration_in_months" do
    context "when start and end dates are valid" do
      it "should return the months diff" do
        experience.duration_in_months.should eq((end_date.to_time - start_date.to_time) / 1.month)
      end

      context "when both start and end dates are the same" do
        let(:end_date) { start_date }
        it "should return 0" do
          experience.duration_in_months.should eq(0)
        end
      end

      context "when start date is greater than end date" do
        let(:end_date) { start_date - 1.day }
        it "should return 0" do
          experience.duration_in_months.should eq(0)
        end
      end
    end

    context "when start date is missing" do
      let(:start_date) { nil }
      it "should return 0" do
        experience.duration_in_months.should eq(0)
      end
    end

    context "when end date is missing" do
      let(:end_date) { nil }

      it "should return the month diff until now" do
        expected_result = ((DateTime.now.to_time - start_date.to_time) / 1.month).round
        experience.duration_in_months.round.should eq(expected_result)
      end
    end
  end
end
