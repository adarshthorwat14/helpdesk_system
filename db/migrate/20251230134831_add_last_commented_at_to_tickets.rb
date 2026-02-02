class AddLastCommentedAtToTickets < ActiveRecord::Migration[8.1]
  def change
    add_column :tickets, :last_commented_at, :datetime
  end
end
