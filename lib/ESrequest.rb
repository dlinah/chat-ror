require 'json'

def ESrequest(type , body=nil )
    require "net/http"
    url = URI.parse('http://es:9200/messages/messages')
    puts body.inspect
    case type
    when :post
      request = Net::HTTP::Post.new(url.path)
      request.body = body
    when :get
      request = Net::HTTP::Get.new(url.path)
    when :put
      request = Net::HTTP::Put.new(url.path)
      request.body = body
    when :delete
      request = Net::HTTP::Delete.new(url.path)
    when :search
      url = URI.parse('http://es:9200/messages/_search')
      request = Net::HTTP::Post.new(url.path+"?filter_path=hits.hits._source.body,hits.hits._source.number")
      request.body = body
    end
    request.content_type = 'application/json'

    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(request)
    }
    res.body
end