class RenameAsigneeToAssignee < ActiveRecord::Migration
  def change
    rename_column :issues, :asignee_id, :assignee_id
  end
end
