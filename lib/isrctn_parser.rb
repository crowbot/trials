# Basic parser for ISRCTN studies. Todos:
# - address information for contacts and sponsors (needs new database fields)
# - check for and over-write existing entries (or manage via history), rather than just creating new ones
# - 

require 'hpricot'
require 'open-uri'

class IsrctnParser

  def initialize  
    @base_url = "http://www.controlled-trials.com/isrctn/"
    @base_path = "http://www.controlled-trials.com"
  end
  
  def get_all_trials()
    get_trial(@base_url)
  end

  # get links to all trials listed on ISRCTN results page: 
  # scrape those trials, then follow 'next page' link recursively
  def get_trial(url)
    page_content = open(url).read()
    doc = Hpricot(page_content)
    tds = doc.search("//td[@id='WhiteText']")
    trial_links = (tds/"a")
    for trial_link in trial_links do
      individual_trial = @base_path + trial_link['href']
      scrape_trial(individual_trial)
    end
    # if there is a 'next' page, go there
    begin
      next_page = doc.at("//a[@title='Next Page of Results']")['href']
      if next_page
        next_link = "http://www.controlled-trials.com" + next_page
        get_trial(next_link)
      end
    rescue
      puts "last page"
    end
  end
  
  # get the properties of each individual trial
  # and save FieldName and FieldValue rows in a hash
  def scrape_trial(trial_url)
    page_content = open(trial_url).read()
    doc = Hpricot(page_content)
    field_names = doc.search("//td[@id='FieldName']")
    field_values = doc.search("//td[@id='FieldValue']")
    name_array = []
    value_array = []
    value_hash = {}
    for name in field_names do
      name = name.inner_text.strip
      name_array << name
    end
    for value in field_values do
      value = value.inner_text.strip
      value = Iconv.iconv("us-ascii//ignore", "iso-8859-1", value) # Not sure this is ideal, but utf8 and latin1 produce errors
      value_array << value[0]
    end
    value_array.each_with_index do |value, index|
      value_hash[name_array[index]] = value
    end
    trial_attributes = get_attributes(trial_url, value_hash)
    # save the trial, unless one with the same ID already exists
    existing = ClinicalTrial.find_by_isrctn_id(trial_attributes[:isrctn_id])
    if !existing && !trial_attributes[:nct_id].blank?
      existing = ClinicalTrial.find_by_nct_id(trial_attributes[:nct_id])
    end
    if existing
      puts "Skipping #{trial_attributes[:isrctn_id]}"
      return 
    else
      puts "Parsing #{trial_attributes[:isrctn_id]}"
    end
    trial = ClinicalTrial.create!(trial_attributes)
    # save extra info - contacts, sponsors, outcomes etc
    raise unless trial.id
    # primary outcome            
    if value_hash["Primary outcome measure(s)"] != ""
      primary_outcome = Outcome.new(:clinical_trial_id => trial.id, 
      :outcome_type => 'primary', 
      :measure => value_hash["Primary outcome measure(s)"])
      primary_outcome.save!
    end
    # secondary outcome       
    if value_hash["Secondary outcome measure(s)"] != ""
      secondary_outcome = Outcome.new(:clinical_trial_id => trial.id, 
      :outcome_type => 'secondary', 
      :measure => value_hash["Secondary outcome measure(s)"])
      secondary_outcome.save!
    end
    # sponsor  
    if value_hash["Sponsor"] != ""                          
      lead_sponsor_name = value_hash["Sponsor"] 
      agency = Agency.find_or_create_by_name(lead_sponsor_name)
      lead_sponsor = Sponsor.create(:agency_id => agency.id, 
      :clinical_trial_id => trial.id,  
      :role => 'lead')
    end
    # contact info     
    if value_hash["Contact name"] != "" 
      last_name = value_hash["Contact name"]
      email = value_hash["Email"]
      contact_model = Contact.create!(:last_name => last_name,  
      :email => email) 
      trial.overall_contact = contact_model
      trial.save!
    end
  end

  # Get attributes & put in hash - leave non-ISRCTN attributes blank
  def get_attributes(trial_url, values_hash)
    trial_attributes = {:url => trial_url, 
      :nct_id => values_hash["ClinicalTrials.gov identifier"], 
      :org_study_id => values_hash["Serial number at source"], 
      :brief_title => values_hash["Public title"],
      :official_title => values_hash["Scientific title"],
      :source => "", # no comparable field 
      :has_data_monitoring_committee => "", # no comparable field
      :summary => values_hash["Study hypothesis"],
      :overall_status => values_hash["Status of trial"],
      :why_stopped => "", # no comparable field
      :phase => "", # no comparable field
      :start_date => values_hash["Anticipated start date"], 
      :end_date => values_hash["Anticipated end date"],
      :completion_date => "", # need to add logic for this
      :completion_date_type => "", # no comparable field
      :primary_completion_date => "", # no comparable field
      :primary_completion_date_type => "", # no comparable field
      :study_type => "", # no comparable field
      :study_design => values_hash["Study design"], 
      :number_of_arms => "", # no comparable field
      :number_of_groups => "", # no comparable field
      :enrollment => values_hash["Target number of participants"], 
      :enrollment_type => "", # no comparable field 
      :verification_date => "", # no comparable field
      :firstreceived_date => values_hash["Date applied"], 
      :lastchanged_date => values_hash["Last edited"],
      :isrctn_id =>  values_hash["ISRCTN"], # ISRCTN-only field
      :ethics_approval => values_hash["Ethics approval"], # ISRCTN-only field
      :acronym => values_hash["Acronym"], # ISRCTN-only field 
      :disease_condition => values_hash["Disease/condition/study domain"], # ISRCTN-only field
      :inclusion_criteria => values_hash["Participants - inclusion criteria"], # ISRCTN-only field
      :exclusion_criteria => values_hash["Participants - exclusion criteria"], # ISRCTN-only field
      :interventions => values_hash["Interventions"], # ISRCTN-only field
      :patient_info_material => values_hash["Patient information material"], # ISRCTN-only field
      :funding_sources => values_hash["Sources of funding"], # ISRCTN-only field
      :trial_website => values_hash["Trial website"], # ISRCTN-only field
      :publications => values_hash["Publications"], # ISRCTN-only field
      :date_isrctn_assigned => values_hash["Date ISRCTN assigned"], # ISRCTN-only field
      :countries_of_recruitment => values_hash["Countries of recruitment"], # ISRCTN-only field
    }
  end

end
