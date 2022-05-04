# frozen_string_literal: true

# this is spends controller
class SpendsController < ApplicationController
  before_action :authenticate_user!

  def new
    @spend = Spend.new
  end

  def create
    @spend = Spend.new(spend_params)
    @spend.user = current_user
    @spend.save
    flash[:notice] = 'Successfully spent!'
    redirect_to root_path
  end

  private

  def spend_params
    params.require(:spend).permit(:amount, :foreign_spend)
  end
end
