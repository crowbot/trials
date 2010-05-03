require 'cgi'
class TrialsHistoryParser < UrlParser
  
  attr_accessor :base_host
  
  def initialize
    @base_host = 'clinicaltrials.gov'
    @base_archive_path = 'archive/'
    @history_path = HISTORY_PATH
  end
  
  def get_history(nct_id)
    request_path = "#{@base_archive_path}#{nct_id}"
    versions_page = get_local_file(request_path)
    version_urls = parse_versions_page(versions_page)
    version_urls.each do |version_url|
      version_page = get_local_file(version_url)
      diff_attributes = parse_diff_file(version_page)
      version_date = version_url.split('/')[3]
      version_history_path = "#{@history_path}/#{nct_id}/#{version_date}"
      FileUtils.mkdir_p(version_history_path)
      f = File.open("#{version_history_path}/before.xml", 'w')
      f.write(diff_attributes[:before])
      f.close
      f = File.open("#{version_history_path}/after.xml", 'w')
      f.write(diff_attributes[:after])
      f.close
    end
  end
  
  def parse_versions_page(html)
    doc = Hpricot(open(html))
    version_urls = []
    doc.search('table.versions a[text()*=Changes]').each do |link|
      version_urls << link[:href]
    end
    version_urls
  end
  
  def parse_diff_file(html)
    # puts "parsing #{html}"
    doc = Hpricot(open(html))
    before_xml = []
    after_xml = []
    doc.search('div#sdiff-full table.sdiff td.sdiff-a').each{ |a_div| before_xml << a_div.inner_text }
    doc.search('div#sdiff-full table.sdiff td.sdiff-b').each{ |b_div| after_xml << b_div.inner_text }
    before_xml = CGI.unescapeHTML(before_xml.join)
    after_xml = CGI.unescapeHTML(after_xml.join)
    { :before => before_xml, 
      :after => after_xml }
  end
  
end