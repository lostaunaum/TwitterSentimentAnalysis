class Addingresultcolumntotweets < ActiveRecord::Migration
  def change
    add_column :users, :result, :string, after: :nickname
  end
end
