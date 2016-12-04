class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :issue_code, null: false
      t.string :name, null: false
      t.integer :project_id, null: false
      t.integer :priority
      t.integer :story_points
      t.integer :sprint
      t.string :label
      t.string :description
      t.integer :status, default: 1
      t.string :environment
      t.integer :asignee_id
      t.integer :reporter_id
      t.float :creation_date

      t.timestamps null: false
    end
  end
end
