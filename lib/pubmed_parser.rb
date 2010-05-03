class PubmedParser < UrlParser

  attr_accessor :base_host
  
  def initialize
    @pubmed_base_path = "/entrez/eutils/esearch.fcgi?tool=trialsearch&email=louise.crow@gmail.com&db=pubmed&retmax=10&term="
    @base_host = 'eutils.ncbi.nlm.nih.gov'
  end
  
  def search_for_trial(nct_id)
    request_path = "#{@pubmed_base_path}#{nct_id}"
    response = request_page(request_path)
    pubmed_ids =  parse_response(response)
    return pubmed_ids
  end
  
  def parse_response(response)
    doc = Hpricot::XML(response)
    pubmed_ids = []
    (doc/:Id).each do |id|
      pubmed_ids << id.inner_text.strip
    end
    pubmed_ids
  end
  
end
