# frozen_string_literal: true

# class IssuePointsForLoyaltyJob
class IssuePointsForLoyaltyJob
  include Sidekiq::Job

  def perform(user_id, spend_id)
    user = User.find(user_id)
    spend = Spend.find(spend_id)
    policy = LoyaltyPointPolicyService.new(user)
    loyalty_point = policy.generate_reward(spend_id)

    spend.loyalties.create(loyalty_point) if loyalty_point
  end
end
