class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
  	rename_column :vars, :general_category, :general_category_id
  end
end
