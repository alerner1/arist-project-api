class CreateDevices < ActiveRecord::Migration[6.1]
  def change
    create_table :devices, id: :uuid do |t|
      t.string :phone_number
      t.string :carrier
      t.datetime :disabled_at, default: nil

      t.timestamps
    end
  end
end
