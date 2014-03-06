module ProjectModelPatch
	
 def self.included(base)
  base.class_eval do
   unloadable
   has_many :standup_reports, :dependent => :destroy
   has_one :non_submission_time
  end
 end

end