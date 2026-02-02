class AddLastViewedAtToTickets < ActiveRecord::Migration[8.1]
  def change
    add_column :tickets, :last_viewed_at, :datetime
  end
end
