# frozen_string_literal: true

# this is home controller
class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_to user_session_path unless user_signed_in?
    @spend = Spend.new
    @loyalty_points = current_user.loyalties.where('loyalties.expiry > ?',
                                                   DateTime.now).where.not(reward_tags: 'standard')
  end
end
