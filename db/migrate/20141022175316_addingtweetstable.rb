class Addingtweetstable < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :user_id
      t.string :tweet
      t.string :sentiment
    end
  end
end
