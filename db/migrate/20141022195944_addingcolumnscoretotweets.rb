class Addingcolumnscoretotweets < ActiveRecord::Migration
  def change
    rename_column :tweets, :sentiment, :type
    add_column :tweets, :score, :integer, after: :type
  end
end
