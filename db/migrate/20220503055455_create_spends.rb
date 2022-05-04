# frozen_string_literal: true

# for create spends table
class CreateSpends < ActiveRecord::Migration[7.0]
  def change
    create_table :spends do |t|
      t.float :amount
      t.datetime :expiry
      t.boolean :foreign_spend
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
