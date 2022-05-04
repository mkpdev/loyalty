# frozen_string_literal: true

# class Spend
class Spend < ApplicationRecord
  belongs_to :user
  has_many :loyalties

  after_save :issue_loyality_points

  def issue_loyality_points
    IssuePointsForLoyaltyJob.perform_async(user.id, id)
  end

  def reward_points
    points = 10
    points = (points * 2) if foreign_spend
    points
  end
end
