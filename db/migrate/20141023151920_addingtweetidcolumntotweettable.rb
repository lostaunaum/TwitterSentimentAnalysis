class Addingtweetidcolumntotweettable < ActiveRecord::Migration
  def change
    add_column :tweets, :twitterId, :string, after: :score
  end
end
