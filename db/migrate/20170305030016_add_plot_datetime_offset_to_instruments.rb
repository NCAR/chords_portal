class AddPlotDatetimeOffsetToInstruments < ActiveRecord::Migration[5.1]
  def change
    add_column :instruments, :plot_offset_value, :integer, :default => 1
    add_column :instruments, :plot_offset_units, :string, :default => :weeks
  end
end
