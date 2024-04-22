class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.string :text
      t.datetime :scheduled_date
      t.string :whatsapp_number

      t.timestamps
    end
  end
end
