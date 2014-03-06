class NonSubmissionTime < ActiveRecord::Base
  unloadable
  belongs_to :project
end
