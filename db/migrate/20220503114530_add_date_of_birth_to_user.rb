# frozen_string_literal: true

# Add new field in users table
class AddDateOfBirthToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :dob, :datetime
  end
end
