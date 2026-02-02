class AddCommentedAtToComments < ActiveRecord::Migration[8.1]
  def change
    add_column :comments, :commented_at, :datetime
  end
end
