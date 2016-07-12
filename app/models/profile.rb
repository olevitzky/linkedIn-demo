class Profile < ActiveRecord::Base
  after_initialize :set_initial_state

  has_many :experiences, -> { order('start_date ASC') }, dependent: :destroy
  has_many :educations, -> { order('first_year ASC') }, dependent: :destroy

  validates :uuid, uniqueness: { case_sensitive: false }

  SKILL_SCORE = 1.5

  state_machine :state, :initial => :draft do

    event :enqueue do
      transition [:draft] => :enqueued
    end
    
    event :process do
      transition [:enqueued] => :processing
    end

    event :complete do
      transition [:processing] => :completed
    end

    event :mark_as_failed do
      transition all => :failed
    end

    after_transition :to => :enqueued, :do => :fetch_linkedin_profile
  end

  def calculate_score!
    self.score = (self.skills.to_a.size * SKILL_SCORE) + 
                (self.educations.inject(0) { |sum, edu| sum + edu.score}) +
                (self.experiences.inject(0) { |sum, exp| sum + exp.score})
    self.save
  end

  def short_summary
    self.summary.try(:truncate, 50)
  end

private
  
  # schedule a background job to build the profile from linkedin
  def fetch_linkedin_profile
    LinkedinParserWorker.perform_async(self.id)
  end

  def set_initial_state
    self.state ||= :draft
  end
end
