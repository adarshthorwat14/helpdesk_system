class CreateTicketActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :ticket_activities do |t|
      t.references :ticket, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :action
      t.text :metadata

      t.timestamps
    end
  end
end
