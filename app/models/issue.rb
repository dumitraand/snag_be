class Issue < ActiveRecord::Base
  belongs_to :project
  belongs_to :asignee, class_name: "User",
                        foreign_key: "asignee_id"
  belongs_to :reporter, class_name: "User",
                        foreign_key: "reporter_id"
end
