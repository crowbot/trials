class PubmedParser < UrlParser

  attr_accessor :base_host
  
  def initialize
    @search_base_path = "/entrez/eutils/esearch.fcgi?tool=trialsearch&email=louise.crow@gmail.com&db=pubmed&retmax=100&term="
    @fetch_base_path = "/entrez/eutils/efetch.fcgi?db=pubmed&retmode=xml&id="
    @base_host = 'eutils.ncbi.nlm.nih.gov'
  end
  
  def search_for_identifier(identifier_field, identifier)
    if !identifier.blank?
      request_path = "#{@search_base_path}#{CGI.escape("\"#{identifier}\"")}"
      puts "Search with #{identifier_field} #{identifier}"
      response = get_local_file(request_path) 
      return parse_search_response(File.read(response))
    end
    return []
  end
  
  def get_info_for_ids(ids)
    if ids.blank?
      return {}
    else
      request_path = "#{@fetch_base_path}#{ids}"
      puts "Search for #{ids}"
      response = get_local_file(request_path)
      return parse_fetch_response(File.read(response))
    end
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
  
  def parse_fetch_response(response)
    ids_to_dates = {}
    doc = Hpricot::XML(response)
    # print doc
    articles = doc.search('PubmedArticle')
    articles.each do |article|
      
      # publication date of the journal issue
      citation = article.at('MedlineCitation')
      pmid = citation.at("PMID").inner_html
      ids_to_dates[pmid] = {}
      journal = citation.at('Article/Journal')
      pub_date = (journal/:JournalIssue/:PubDate)
      year = pub_date.at('Year') ? pub_date.at('Year').inner_html : nil
      month = pub_date.at('Month') ? pub_date.at('Month').inner_html : nil
      day = pub_date.at('Day') ? pub_date.at('Day').inner_html : nil
      season = pub_date.at('Season') ? pub_date.at('Season').inner_html : nil
      medline_date = pub_date.at('MedlineDate') ? pub_date.at('MedlineDate').inner_html : nil
      issue_pub_date = { :year => year, 
                         :month => month,
                         :day => day, 
                         :season => season, 
                         :medline_date => medline_date }
      if existing = ids_to_dates[pmid][:issue_pub_date]
        puts "EXISTING #{existing[:year]} #{existing[:month]} #{existing[:day]} #{existing[:season]} #{existing[medline_date]}"
      end
      ids_to_dates[pmid][:issue_pub_date] = issue_pub_date
      
      # pubmed dates
      history = article.at('History')
      pubmed_dates = []
      history.search('PubMedPubDate').each do |pubmed_date_element|
        pubmed_date = {}
        pubmed_date[:type] = pubmed_date_element.attributes['PubStatus']
        pubmed_date[:year] = pubmed_date_element.at('Year').inner_html
        pubmed_date[:month] = pubmed_date_element.at('Month').inner_html
        pubmed_date[:day] = pubmed_date_element.at('Day').inner_html
        pubmed_date[:minute] = pubmed_date_element.at('Minute') ? pubmed_date_element.at('Minute').inner_html : nil
        pubmed_dates << pubmed_date
      end
      ids_to_dates[pmid][:pubmed_dates] = pubmed_dates
      
      # article date
      article = citation.at('Article')
      article_dates = []
      article.search('ArticleDate').each do |article_date_element|
        article_date = {}
        article_date[:type] = article_date_element.attributes['DateType']
        article_date[:year] = article_date_element.at('Year').inner_html
        article_date[:month] = article_date_element.at('Month').inner_html
        article_date[:day] = article_date_element.at('Day').inner_html
        article_dates << article_date
      end
      ids_to_dates[pmid][:article_dates] = article_dates
    end
    ids_to_dates
  end
  
  def parse_search_response(response)
    doc = Hpricot::XML(response)
    pubmed_ids = []
    # don't count results where the identifier got broken up and re searched as component parts
    print 
    if (doc/:QuotedPhraseNotFound).empty?
      (doc/:Id).each do |id|
        puts "Adding #{id.inner_text.strip}"
        pubmed_ids << id.inner_text.strip
      end
    end
    pubmed_ids
  end
  
end
