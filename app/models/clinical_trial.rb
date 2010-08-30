# == Schema Information
# Schema version: 20100318145341
#
# Table name: clinical_trials
#
#  id                            :integer(11)     not null, primary key
#  url                           :string(255)
#  nct_id                        :string(255)
#  org_study_id                  :string(255)
#  secondary_ids                 :string(255)
#  brief_title                   :string(255)
#  official_title                :string(255)
#  source                        :string(255)
#  has_data_monitoring_committee :boolean(1)
#  summary                       :text
#  overall_status                :string(255)
#  start_date                    :date
#  end_date                      :date
#  completion_date               :string(255)
#  completion_date_type          :string(255)
#  primary_completion_date       :string(255)
#  primary_completion_date_type  :string(255)
#  phase                         :string(255)
#  study_type                    :string(255)
#  study_design                  :string(255)
#  enrollment                    :integer(11)
#  enrollment_type               :string(255)
#  condition_id                  :integer(11)
#  created_at                    :datetime
#  updated_at                    :datetime
#

class ClinicalTrial < ActiveRecord::Base
  has_many :sponsors
  has_one :lead_sponsor, :class_name => 'Sponsor', :conditions => "role = 'lead'"
  has_many :collaborators, :class_name => 'Sponsor', :conditions => "role ='collaborator'"
  belongs_to :overall_contact, :class_name => 'Contact'
  belongs_to :overall_contact_backup, :class_name => 'Contact'
  has_one :overall_official
  has_many :locations, :foreign_key => :trial_id
  has_many :trial_mentions
  has_many :articles, :through => :trial_mentions, :uniq => true
  before_create :set_completion_date_as_date
  has_many :trial_interventions
  has_many :interventions, :through => :trial_interventions, :uniq => true
  has_many :condition_trials
  has_many :conditions, :through => :condition_trials, :uniq => true
  
  def self.per_page
    20
  end
  
  named_scope :completed, :conditions => "completion_date is not null"
  
  named_scope :unpublished, :select => 'clinical_trials.*',
                            :joins => ["LEFT OUTER JOIN trial_mentions 
                                        ON clinical_trials.id = trial_mentions.clinical_trial_id"], 
                            :conditions => "trial_mentions.id is NULL"
  named_scope :published, :select => 'clinical_trials.*',
                            :joins => ["LEFT OUTER JOIN trial_mentions 
                                        ON clinical_trials.id = trial_mentions.clinical_trial_id"], 
                            :conditions => "trial_mentions.id is not NULL"
  named_scope :searched, :conditions => ['searched = ?', true]
  named_scope :three_years_old, lambda { { :conditions => ["completion_date_as_date < ?", Time.now - 3.years] } }

  def analyse_history
    return nil if nct_id.blank?
    history_dir = File.join(HISTORY_PATH, nct_id)
    if !File.exist?(history_dir)
      return nil
    end
    trials_parser = TrialsParser.new
    changes = {}
    Dir.glob(File.join(history_dir, "*")).each do |filename|
      date = File.basename(filename)
      date = Date.parse(date.gsub('_', '/')).to_s(:long)
      before = File.join(filename, "before.xml")
      after = File.join(filename, "after.xml")
      before_trial_attributes = trials_parser.get_trial_attributes(before)
      after_trial_attributes = trials_parser.get_trial_attributes(after)

      before_trial_attributes.each do |key, value|
        was = before_trial_attributes[key]
        now = after_trial_attributes[key]
        if was != now
          changes[date] = {} if ! changes[date]
          was = was ? was.strip : was 
          now = now ? now.strip : now
          changes[date][key] = {:old => was, :new => now}
        end
      end
    end
    changes
  end
  
  def set_completion_date_as_date
    if !self.completion_date.blank?
      self.completion_date_as_date = Date.parse(self.completion_date)
    end
  end
  
  def self.search(search)
    if search
      find(:all, :conditions => ["nct_id = ? or brief_title LIKE ? or official_title LIKE ?", search, "% #{search} %", "% #{search} %"], :order => 'id DESC')
    else
      find(:all, :order => 'id DESC')
    end
  end
        
end
