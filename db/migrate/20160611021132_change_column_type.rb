class ChangeColumnType < ActiveRecord::Migration
  def self.up
     change_column :cheques, :value, :decimal, :precision => 6, :scale => 2
  end
  def self.down
     change_column :cheques, :value, :integer
  end
end
