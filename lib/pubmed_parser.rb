class PubmedParser < UrlParser

  attr_accessor :base_host
  
  def initialize
    @pubmed_base_path = "/entrez/eutils/esearch.fcgi?tool=trialsearch&email=louise.crow@gmail.com&db=pubmed&retmax=10&term="
    @base_host = 'eutils.ncbi.nlm.nih.gov'
  end
  
  def search_for_trial(trial)
    pubmed_ids = []
    identifier_fields = [:nct_id, :nct_alias, :org_study_id, :isrctn_id]
    identifier_fields.each do |identifier_field|
      identifier_value = trial.send(identifier_field)
      if !identifier_value.blank?
        request_path = "#{@pubmed_base_path}#{CGI.escape("\"#{identifier_value}\"")}"
        puts "Search with #{identifier_field} #{identifier_value}"
        response = request_page(request_path)
        pubmed_ids += parse_response(response)
      end
    end
    pubmed_ids.compact!
    return pubmed_ids
  end
  
  def parse_response(response)
    doc = Hpricot::XML(response)
    pubmed_ids = []
    # don't count results where the identifier got broken up and re searched as component parts
    if (doc/:QuotedPhraseNotFound).empty?
      (doc/:Id).each do |id|
        puts "Adding #{id.inner_text.strip}"
        pubmed_ids << id.inner_text.strip
      end
    end
    pubmed_ids
  end
  
end
