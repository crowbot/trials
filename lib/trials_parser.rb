require 'hpricot'

class TrialsParser

  def initialize  
  end
  
  def parse_file(file_path)
    xml = File.read(file_path)
    doc = Hpricot::XML(xml)
    url = (doc/:required_header/:url).text
    nct_id = (doc/:id_info/:nct_id).text
    org_study_id = (doc/:org_study_id).text
    brief_title = (doc/:brief_title).text
    official_title = (doc/:official_title).text
    lead_sponsor_name = (doc/:sponsors/:lead_sponsor/:agency).text
    collaborator_elements = doc.at('sponsors').search('collaborator')
    authorities = doc.at('oversight_info').search('authority')
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
    overall_status = (doc/:overall_status).text
    why_stopped = (doc/:why_stopped).text
    phase = (doc/:phase).text
    trial = ClinicalTrial.create(:url => url, 
                                 :nct_id => nct_id, 
                                 :org_study_id => org_study_id,
                                 :brief_title => brief_title,
                                 :official_title => official_title,
                                 :source => source, 
                                 :has_data_monitoring_committee => has_data_monitoring_committee,
                                 :summary => summary, 
                                 :overall_status => overall_status,
                                 :why_stopped => why_stopped, 
                                 :phase => phase)
    authorities.each do |authority_name|
      authority = Authority.create(:name => authority_name.text)
      Overseer.create(:authority_id => authority.id, 
                      :clinical_trial_id => trial.id)
    end                          
    agency = Agency.find_or_create_by_name(lead_sponsor_name)
    lead_sponsor = Sponsor.create(:agency_id => agency.id, 
                                  :clinical_trial_id => trial.id, 
                                  :role => 'lead')
    collaborator_elements.each do |collaborator|
      collaborator_name = collaborator.text
      agency = Agency.find_or_create_by_name(collaborator_name)
    end
  end
  
end
