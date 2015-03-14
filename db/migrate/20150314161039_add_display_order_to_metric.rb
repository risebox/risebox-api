class AddDisplayOrderToMetric < ActiveRecord::Migration
  def change
    add_column :metrics, :display_order, :integer
  end
end
