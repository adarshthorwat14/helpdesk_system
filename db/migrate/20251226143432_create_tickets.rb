class CreateTickets < ActiveRecord::Migration[8.1]
  def change
    create_table :tickets do |t|
      t.string :title
      t.text :description
      t.string :status
      t.string :priority
      t.string :category
      t.integer :user_id
      t.integer :agent_id 

      t.timestamps
    end
  end
end
