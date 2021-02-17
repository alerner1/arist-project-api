class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports, id: :uuid do |t|
      t.string :sender
      t.string :message
      t.belongs_to :device, null: false, foreign_key: true, type: :uuid

    end
  end
end
