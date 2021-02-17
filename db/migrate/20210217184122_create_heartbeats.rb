class CreateHeartbeats < ActiveRecord::Migration[6.1]
  def change
    create_table :heartbeats, id: :uuid do |t|
      t.datetime :created_at
      t.belongs_to :device, null: false, foreign_key: true, type: :uuid

    end
  end
end
