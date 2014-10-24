class Addingcolumnsdecimals < ActiveRecord::Migration
  
  def self.up
   change_column :tweets, :score, :decimal
  end

  def self.down
   change_column :tweets, :score, :integer
  end
end
