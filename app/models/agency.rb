class Agency < ActiveRecord::Base
  has_many :sponsors
  has_many :clinical_trials, :through => :sponsors
  
  def self.by_unpublished_completed(limit=10)
    find_by_sql(["select agencies.*, cnt
                 FROM agencies, (SELECT agency_id, count(*) as cnt
                                 FROM sponsors 
                                 WHERE clinical_trial_id in 
                                      (SELECT clinical_trials.id 
                                      FROM `clinical_trials` 
                                      LEFT OUTER JOIN trial_mentions       
                                      ON clinical_trials.id = trial_mentions.clinical_trial_id 
                                      WHERE completion_date_as_date < ? 
                                      AND trial_mentions.id is NULL
                                      AND searched = 1
                                      AND completion_date is not null)
                                      GROUP BY agency_id) as tmp
                  WHERE agencies.id = agency_id 
                  ORDER BY cnt
                  LIMIT #{limit};", Time.now.beginning_of_month - 3.years])
    
  end
  
end
