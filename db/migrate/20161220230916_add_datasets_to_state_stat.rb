class AddDatasetsToStateStat < ActiveRecord::Migration[5.0]
  def change
    rename_column :state_stats, :dataset, :main_ds
    rename_column :state_stats, :metrics, :main_mt
    add_column :state_stats, :vl_rate_ds, :string
    add_column :state_stats, :vl_rate_mt, :text, array: true
    add_column :state_stats, :perc_ds, :string
    add_column :state_stats, :perc_mt, :text, array: true
  end
end
