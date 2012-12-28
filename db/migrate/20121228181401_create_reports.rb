class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :project_id, :null => false
      t.integer :code
      t.integer :delay
      t.timestamps
    end

    add_index :reports, :project_id
    add_index :reports, [:project_id, :created_at]
  end
end
