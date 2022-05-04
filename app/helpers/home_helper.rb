# frozen_string_literal: true

# Home helper
module HomeHelper
  def title_formatter(title)
    {
      standard: 'Loyalty Points',
      free_coffee: 'Free Coffee',
      rebate: '5% Rebate',
      movie_ticket: 'Free Movie Ticket',
      airport_lounge_access: '4x Airport Lounge Access'
    }.with_indifferent_access[title]
  end

  def expiry_time(reward)
    reward.expiry.strftime('%F')
  end
end
