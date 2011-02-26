require 'hpricot'
# Fast-and loose parser for clinical trials data in XML format - one trial per file, as available
# from clinicaltrials.gov.
# TODO: Needs proper checking against http://clinicaltrials.gov/ct2/html/images/info/public.dtd
# TODO: Should probably just yield up unsaved objects
class TrialsParser

  def initialize
  end

  def parse_contact contact_element, container_element
    if contact = container_element.at(contact_element)
      last_name = contact.at('last_name') ? contact.at('last_name').inner_text : nil
      phone = contact.at('phone') ? contact.at('phone').inner_text : nil
      phone_ext = contact.at('phone_ext') ? contact.at('phone_ext').inner_text : nil
      email = contact.at('email') ? contact.at('email').inner_text : nil
      contact_model = Contact.create!(:last_name => last_name,
                                      :phone => phone,
                                      :phone_ext => phone_ext,
                                      :email => email)
    end
  end

  def get_trial_attributes(file_path, only_nct=false)
    xml = File.read(file_path)
    doc = Hpricot::XML(xml)
    nct_id = (doc/:id_info/:nct_id).text
    
    nct_aliases = doc.search('nct_alias').map{ |nct_alias| nct_alias.inner_text }.join(",")
    if ! only_nct
      url = (doc/:required_header/:url).text
      download_date = (doc/:required_header/:download_date).text
      org_study_id = (doc/:org_study_id).text
      secondary_ids = doc.search('secondary_id').map{ |secondary_id_element| secondary_id_element.inner_text }.join(",")
      brief_title = (doc/:brief_title).text
      official_title = (doc/:official_title).text
      source = (doc/:source).text
      has_dmc = (doc/:oversight_info/:has_dmc).text
      if has_dmc == 'Yes'
        has_data_monitoring_committee = true
      elsif has_dmc == 'No'
        has_data_monitoring_committee = false
      else
        has_data_monitoring_committee = nil
      end
      summary = (doc/:brief_summary/:textblock).text
      status_element = (doc/:overall_status).empty? ? (doc/:status_block/:status) : (doc/:overall_status)
      overall_status = status_element.text
      why_stopped = (doc/:why_stopped).text
      phase = (doc/:phase).text
      start_date = (doc/:start_date).text
      end_date = (doc/:end_date).text
      completion_date = doc.at('completion_date') ? doc.at('completion_date').inner_text : nil
      completion_date_type = doc.at('completion_date') ? doc.at('completion_date').attributes['type'] : nil
    
      primary_completion_date = doc.at('primary_completion_date') ? doc.at('primary_completion_date').inner_text : nil
      primary_completion_date_type = doc.at('primary_completion_date') ? doc.at('primary_completion_date').attributes['type'] : nil
      phase = (doc/:phase).text
      study_type = (doc/:study_type).text
      study_design = (doc/:study_design).text
      if number_of_arms = (doc/:number_of_arms)
        number_of_arms = number_of_arms.text
      end
      if number_of_groups = (doc/:number_of_groups)
        number_of_groups = number_of_groups.text
      end
      if enrollment = doc.at('enrollment')
        enrollment_type = enrollment.attributes['type']
        enrollment = enrollment.inner_text
      else
        enrollment_type = nil
      end
      verification_date = doc.at('verification_date') ? doc.at('verification_date').inner_text : nil
      firstreceived_date = doc.at('firstreceived_date') ? doc.at('firstreceived_date').inner_text : nil
      lastchanged_date = doc.at('lastchanged_date') ? doc.at('lastchanged_date').inner_text : nil
    end
    if nct_only
      trial_attributes = { :nct_id => nct_id,
                           :nct_aliases => nct_aliases }
    else
      trial_attributes = {:url => url,
                          :download_date => download_date,
                         :nct_id => nct_id,
                         :secondary_ids => secondary_ids,
                         :org_study_id => org_study_id,
                         :nct_aliases => nct_aliases,
                         :brief_title => brief_title,
                         :official_title => official_title,
                         :source => source,
                         :has_data_monitoring_committee => has_data_monitoring_committee,
                         :summary => summary,
                         :overall_status => overall_status,
                         :why_stopped => why_stopped,
                         :phase => phase,
                         :start_date => start_date,
                         :end_date => end_date,
                         :completion_date => completion_date,
                         :completion_date_type => completion_date_type,
                         :primary_completion_date => primary_completion_date,
                         :primary_completion_date_type => primary_completion_date_type,
                         :phase => phase,
                         :study_type => study_type,
                         :study_design => study_design,
                         :number_of_arms => number_of_arms,
                         :number_of_groups => number_of_groups,
                         :enrollment => enrollment,
                         :enrollment_type => enrollment_type,
                         :verification_date => verification_date,
                         :firstreceived_date => firstreceived_date,
                         :lastchanged_date => lastchanged_date}
    end
    return trial_attributes
  end

  def parse_file(file_path)
    xml = File.read(file_path)
    doc = Hpricot::XML(xml)
    trial_attributes = get_trial_attributes(file_path)
    existing = ClinicalTrial.find_by_nct_id(trial_attributes[:nct_id])
    if existing
      puts "Skipping #{trial_attributes[:nct_id]}"
      return
    else
      puts "Parsing #{trial_attributes[:nct_id]}"
    end
    trial = ClinicalTrial.create!(trial_attributes)
    raise unless trial.id
    doc.search('overall_official').each do |official|
      overall_official = OverallOfficial.new(:name => official.at('last_name').inner_text,
                                             :clinical_trial_id => trial.id)
      if official.at('role')
        overall_official.role = official.at('role').inner_text
      end
      if official.at('affiliation')
        affiliation = official.at('affiliation').inner_text
        agency = Agency.find_or_create_by_name(affiliation.strip)
        overall_official.agency_id = agency.id
      end
      overall_official.save!
    end

    if overall_contact = parse_contact('overall_contact', doc)
      trial.overall_contact = overall_contact
      trial.save!
    end
    if overall_contact_backup = parse_contact('overall_contact_backup', doc)
      trial.overall_contact_backup = overall_contact_backup
      trial.save!
    end

    if doc.search('primary_outcome')
      primary_outcome = Outcome.new(:clinical_trial_id => trial.id,
                                    :outcome_type => 'primary',
                                    :measure => (doc/:primary_outcome/:measure).text)
      if time_frame = (doc/:primary_outcome/:time_frame)
        primary_outcome.time_frame = time_frame.text
      end
      if safety_issue = (doc/:primary_outcome/:safety_issue)
        primary_outcome.safety_issue = safety_issue.text
      end
      if description = (doc/:primary_outcome/:description)
        primary_outcome.description = description.text
      end
      primary_outcome.save!
    end

    if doc.search('secondary_outcome')
      secondary_outcome = Outcome.new(:clinical_trial_id => trial.id,
                                    :outcome_type => 'secondary',
                                    :measure => (doc/:secondary_outcome/:measure).text)
      if time_frame = (doc/:secondary_outcome/:time_frame)
        secondary_outcome.time_frame = time_frame.text
      end
      if safety_issue = (doc/:secondary_outcome/:safety_issue)
        secondary_outcome.safety_issue = safety_issue.text
      end
      if description = (doc/:secondary_outcome/:description)
        secondary_outcome.description = description.text
      end
      secondary_outcome.save!
    end
    authorities = doc.at('oversight_info').search('authority')
    authorities.each do |authority_name|
      authority = Authority.create(:name => authority_name.inner_text)
      Overseer.create(:authority_id => authority.id,
                      :clinical_trial_id => trial.id)
    end
    if doc.at('study_sponsor')
      sponsor_element = :study_sponsor
    else
      sponsor_element = :sponsors
    end
    lead_sponsor_name = (doc/sponsor_element/:lead_sponsor/:agency).text
    agency = Agency.find_or_create_by_name(lead_sponsor_name.strip)
    collaborator_elements = doc.at(sponsor_element).search('collaborator')
    lead_sponsor = Sponsor.create(:agency_id => agency.id,
                                  :clinical_trial_id => trial.id,
                                  :role => 'lead')
    collaborator_elements.each do |collaborator|
      collaborator_name = collaborator.inner_text
      agency = Agency.find_or_create_by_name(collaborator_name.strip)
      collaborator = Sponsor.create(:agency_id => agency.id,
                                    :clinical_trial_id => trial.id,
                                    :role => 'collaborator')
    end
    doc.search("location").each do |location|
      facility_name = location.at("facility name") ? location.at("facility name").inner_text : nil
      address = location.at("address")
      city = address.at('city') ? address.at('city').inner_text : nil
      state = address.at('state') ? address.at('state').inner_text : nil
      zip = address.at('zip') ? address.at('zip').inner_text : nil
      country = address.at('country').inner_text
      status = location.at('status').inner_text

      facility = Facility.create(:name => facility_name,
                                 :city => city,
                                 :state => state,
                                 :zip => zip,
                                 :country => country)
       contact = parse_contact('contact', location)
       backup_contact = parse_contact('contact_backup', location)
       location_model = Location.create(:facility_id => facility.id,
                                        :trial_id => trial.id,
                                        :status => status,
                                        :contact => contact,
                                        :backup_contact => backup_contact)
       location.search('investigator').each do |investigator|
         if investigator.at('role')
           role = investigator.at('role').inner_text
         else
           role = nil
         end
         Investigator.create(:last_name => investigator.at("last_name").inner_text,
                             :role => role,
                             :location_id => location_model.id)
       end
       if responsible_party = doc.at('responsible_party')
         name = responsible_party.at('name_title') ? responsible_party.at('name_title').inner_text : nil
         organization = responsible_party.at('organization') ? responsible_party.at('organization').inner_text : nil
         party = ResponsibleParty.create(:name_title => name,
                                         :organization => organization,
                                         :clinical_trial_id => trial.id)
       end
    end

    doc.search("intervention").each do |intervention_element|
      intervention_type_name = intervention_element.at('intervention_type').inner_text
      intervention_type = InterventionType.find_or_create_by_name(intervention_type_name)
      intervention_name = intervention_element.at("intervention_name").inner_text
      intervention = Intervention.find_or_create_by_name_and_intervention_type_id(intervention_name, intervention_type.id)
      trial_intervention = TrialIntervention.create(:clinical_trial_id => trial.id,
                                                    :intervention_id => intervention.id)
    end

    doc.search("condition").each do |condition_element|
      condition_name = condition_element.inner_text
      condition = Condition.find_or_create_by_name(condition_name)
      condition_trial = ConditionTrial.create(:clinical_trial_id => trial.id,
                                              :condition_id => condition.id)
    end
  end
end
