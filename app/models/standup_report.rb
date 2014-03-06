class StandupReport < ActiveRecord::Base
  unloadable
  belongs_to :project
end
