class ChangingColumnNameforTweets < ActiveRecord::Migration
  def change
    rename_column :tweets, :type, :sentiment_type
  end
end
