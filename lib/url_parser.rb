require 'httpclient'
require 'hpricot'
require 'digest/sha1'

class UrlParser 
  
  def request_page(request_path)
    sleep(0.3)
    http_client = HTTPClient.new
    url = "http://#{base_host}#{request_path}"
    puts url
    content = http_client.get_content(url)
    return content
  end
  
  def data_dir
    "data/"
  end
   

  def get_local_file(page)
    page = page.gsub(/^\//, '')
    request_path = "/#{page}"
    local_path = "#{data_dir}#{page}.html"
    filename = File.basename(local_path)
    dirname = File.dirname(local_path)
    if filename.size > 100
      local_path = File.join(pathname, Digest::SHA1.hexdigest(filename))
      print local_path
    end
    local_file = File.exist?(local_path)   
    return local_path if local_file 
     
    body = nil
    puts "getting #{request_path}"
    begin
     content = request_page(request_path)
    rescue
     # 1 retry
     puts "retrying #{request_path}"
     content = request_page(request_path)
    end
    directory = File.dirname(local_path)
    FileUtils.mkdir_p(directory)
    f = File.open(local_path, 'w')
    f.write(content)
    f.close
    local_path
  end
end