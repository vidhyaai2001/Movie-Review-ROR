class AddUserReferenceToReviews < ActiveRecord::Migration[7.1]
  def change
    add_reference :reviews, :user, null: false, foreign_key: true
    remove_column :reviews, :name
  end
end
