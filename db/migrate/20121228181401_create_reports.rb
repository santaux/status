class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :project_id,    :null => false
      t.integer :code,          :null => false, :default => 0
      t.integer :delay,         :null => false, :default => 0
      t.integer :response_time, :null => false, :default => 0
      t.string  :message,       :null => false
      t.timestamps
    end

    add_index :reports, :project_id
    add_index :reports, :created_at
    add_index :reports, [:project_id, :code]
  end
end
