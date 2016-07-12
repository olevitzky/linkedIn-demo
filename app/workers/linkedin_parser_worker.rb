class LinkedinParserWorker
  include Sidekiq::Worker

  sidekiq_options retry: 3

  def perform(profile_id)
    profile = Profile.find_by_id(profile_id)
    profile.mark_as_failed and return if profile.nil?

    if profile.process
      if ProfileParser.parse_linkedin_profile(profile)
        # when the process finished successfully
        profile.reload.complete
      else
        # when something went wrong during the process
        profile.reload.mark_as_failed
      end
    end
  end
end