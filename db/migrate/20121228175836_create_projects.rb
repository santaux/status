class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :namespace, :null => false
      t.string :name, :null => false
      t.string :host, :null => false
      t.string :description
      t.timestamps
    end
  end
end
