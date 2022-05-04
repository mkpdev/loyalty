# frozen_string_literal: true

# class User
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :spends
  has_many :loyalties, through: :spends

  scope :new_gold_tier_members, -> { where(gold_tier_time: Date.yesterday.beginning_of_day..Date.yesterday.end_of_day) }

  def total_rewards_earned
    not_expired_loyalty_points.sum(:points)
  end

  def last_reward_date
    not_expired_loyalty_points&.order(created_at: :desc)&.first&.spend&.created_at
  end

  def birthday_month?
    dob.month == Date.today.month
  end

  def coffee_rewardable?
    points = not_expired_loyalty_points.where(created_at: Date.today.beginning_of_month..Date.today)
    points.sum(:amount) > 100
  end

  def rebatable_spends
    spends.where('amount > ? AND created_at > ?', 100, last_rebate_date)
  end

  def first_sixty_days_spends
    spends.where('created_at > ?', (created_at + 60.days))&.sum(:amount)
  end

  def quarterly_spend
    spends.where('created_at > ?', 3.months.ago).sum(:amount)
  end

  def standard_member?
    loyalty_tier == 'standard'
  end

  def gold_member?
    loyalty_tier == 'gold'
  end

  def platinum_member?
    loyalty_tier == 'platinum'
  end

  def last_spend
    spends.order(created_at: :desc).first
  end

  private

  def last_rebate_date
    not_expired_loyalty_points.where(reward_tags: 'rebate').order(created_at: :desc).first&.created_at
  end

  def loyalty_tier
    points = not_expired_loyalty_points.sum(:points)

    if points < 1000
      'standard'
    elsif points < 5000
      'gold'
    elsif points > 5000
      'platinum'
    end
  end

  def not_expired_loyalty_points
    loyalties.where(created_at: 1.year.ago..DateTime.now)
  end
end
