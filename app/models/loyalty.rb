# frozen_string_literal: true

# class Loyalty
class Loyalty < ApplicationRecord
  belongs_to :spend

  before_save :update_expiry
  before_save :check_point_type

  enum reward_tags: %i[standard free_coffee rebate movie_ticket airport_lounge_access]

  def update_expiry
    self.expiry = DateTime.now + 1.year
  end

  def check_point_type
    self.points = 0 if reward_tags != 'standard'
  end
end
