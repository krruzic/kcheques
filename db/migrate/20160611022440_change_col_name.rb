class ChangeColName < ActiveRecord::Migration
  def self.up
    rename_column :cheques, :value, :money
  end

  def self.down
    # rename back if you need or do something else or do nothing
  end
end
