require 'rails_helper'

RSpec.describe Education, type: :model do
  let(:first_year) { 2008 }
  let(:final_year) { 2020 }
  let(:education) { build_stubbed(:education, :first_year => first_year, :final_year => final_year) }
  
  describe "total_years" do
    context "when first and final years are valid" do
      it "should return valid total years of education" do
        education.total_years.should eq(education.final_year - education.first_year)      
      end
    end

    context "when first year is missing" do
      let(:first_year) { nil }
      it "should return 0" do
        education.total_years.should eq(0)
      end
    end

    context "when final year is missing" do
      let(:final_year) { nil }
      it "should return the years diff until now" do
        this_year = Time.now.year
        education.total_years.should eq(this_year - first_year)
      end
    end
  end
end
