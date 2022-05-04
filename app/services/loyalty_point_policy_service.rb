# frozen_string_literal: true

# class LoyaltyPointPolicyService
class LoyaltyPointPolicyService
  attr_reader :user, :spend

  MINIMUM_SPEND = 1_00
  MINIMUM_REBATABLE_SPEND = 10
  FIRST_SIXTY_DAY_SPEND = 1_000

  def initialize(user)
    @user = user
  end

  def coffee_reward?
    user.birthday_month? || user.coffee_rewardable?
  end

  def rebatable?
    user.rebatable_spends.count > MINIMUM_REBATABLE_SPEND
  end

  def movie_ticket?
    user.first_sixty_days_spends > FIRST_SIXTY_DAY_SPEND
  end

  def four_times_airport_lounge_access?
    user.gold_member?
  end

  def bonus_point_eligible?
    user.quarterly_spend
  end

  def generate_reward(spend_id)
    if rewardable?
      @spend = Spend.find(spend_id)
      reward = standard_reward

      reward[:reward_tags] = 'free_coffee' if coffee_reward?

      reward[:reward_tags] = 'rebate' if rebatable?

      reward[:reward_tags] = 'movie_ticket' if movie_ticket?

      reward
    end
  end

  def quarterly_reward
    if user.gold_member?
      spend = user.last_spend
      reward = standard_reward
      reward[:reward_tags] = 'airport_lounge_access'
      spend.loyalty_points.create(reward)
    end
  end

  private

  def rewardable?
    spends = user.spends
    if user.last_reward_date
      spends = spends.where(
        'created_at > ?',
        user.last_reward_date
      )
    end

    spends.sum(:amount) > 100
  end

  def standard_reward
    {
      points: spend.reward_points,
      expiry: (DateTime.now + 1.year),
      reward_tags: 'standard'
    }
  end
end
