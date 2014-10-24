class AddAllColumnsForUser < ActiveRecord::Migration
  def change
    rename_column :users, :email, :description
    add_column :users, :location, :string, after: :description
  end
end
