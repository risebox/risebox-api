class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.string :name
      t.string :code

      t.timestamps null: false
    end

    add_index :metrics, :code
  end
end
