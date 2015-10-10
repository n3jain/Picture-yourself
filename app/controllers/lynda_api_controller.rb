class LyndaApiController < ApplicationController
  require 'net/http'
  require "digest"
  require "json"

  # Given a list of skills, search for Lynda courses
  # and return json course objects
  # 
  # @param [Array<String>] array of strings
  def search_courses
    skills = params[:skills]
    search_for_course(skills)
    # skills.each do |skill|
    #   search_for_course(skill)
    # end

  end

  
  def self.get_json(url)
    uri = URI("https://api-1.lynda.com#{url}")

    if uri.query != nil
        uri.query = "?" + uri.query
    end
    
    headers = {
      'appkey' => "DD5635D3657F48918CE5FEC2C7B97F8E",
      'timestamp' => Time.now.utc.to_i.to_s,
      'hash' => generate_api_hash("#{uri.path}#{uri.query}")
    }    
 
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new("#{uri.path}#{uri.query}", headers)
    response = http.request(request)

    begin
      json = JSON.load(response.body)
    rescue
      json = []
    end

    json
  end
  
  private 

  def search_for_course(query)
    search_url = "/search?"
    search_url += "q=#{query}"
    search_url += "&product_type=2" #only return Courses
    search_url += "&filter.includes=Courses.Title,Courses.Description,Courses.ShortDescription,Courses.Tags.Typename,Courses.Tags.Name,Courses.URLs"

    results = LyndaApiController.get_json(search_url)
    render :json => results 
  end
  
  def self.generate_api_hash(url)
    hash = ""
    hash << "DD5635D3657F48918CE5FEC2C7B97F8E"
    hash << "7CB2B51A63F3420398174E47352A08D9"
    hash << "https://api-1.lynda.com"
    hash << url 
    hash << Time.now.utc.to_i.to_s
    return Digest::MD5.hexdigest(hash)
  end
end
