class PubmedParser < UrlParser

  attr_accessor :base_host
  
  def initialize
    @pubmed_base_path = "/entrez/eutils/esearch.fcgi?tool=trialsearch&email=louise.crow@gmail.com&db=pubmed&retmax=100&term="
    @base_host = 'eutils.ncbi.nlm.nih.gov'
  end
  
  def search_for_identifier identifier_field, identifier
    if !identifier.blank?
      sleep(3)
      request_path = "#{@pubmed_base_path}#{CGI.escape("\"#{identifier}\"")}"
      puts "Search with #{identifier_field} #{identifier}"
      response = request_page(request_path) 
      return parse_response(response)
    end
    return []
  end
  
  def search_for_trial(trial)
    pubmed_ids = []
    identifier_fields = [:nct_id, :nct_alias, :isrctn_id]
    identifier_fields.each do |identifier_field|
      identifier_value = trial.send(identifier_field)
      pubmed_ids += search_for_identifier(identifier_field, identifier_value)
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
