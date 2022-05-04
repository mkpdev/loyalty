# frozen_string_literal: true

# for create loyalties table
class CreateLoyalties < ActiveRecord::Migration[7.0]
  def change
    create_table :loyalties do |t|
      t.float :points
      t.datetime :expiry
      t.integer :reward_tags
      t.references :spend, null: false, foreign_key: true

      t.timestamps
    end
  end
end
