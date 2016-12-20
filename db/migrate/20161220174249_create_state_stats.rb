class CreateStateStats < ActiveRecord::Migration[5.0]
  def change
    create_table :state_stats do |t|
      t.string :state
      t.string :dataset
      t.text :metrics, array: true
      
      t.timestamps
    end
  end
end
