class LyndaApiController < ApplicationController
  require 'net/http'
  require "digest"
  require "json"


  def test_search_courses
    skills = params[:skills]
    skills = [skills] unless skills.kind_of?(Array)
    render :json => LyndaApiController.search_courses(skills)
  end

  # Given a list of skills, search for Lynda courses
  # and return json course objects
  # 
  # @param [Array<String>] array of strings
  def self.search_courses(skills)    
    # fetch results
    results = {}
    skills.each do |skill|
       results[skill] = self.search_for_course(skill)
    end


    # remove any duplicate courses
    courses_for_skills = {}
    course_ids = Set.new
    results.each do |skill, result|
      courses_for_skills[skill] = []
      courses = result["Courses"]

      courses.each do |course|
        id = course["ID"]
        unless course_ids.include?(id)
          course_ids << id
          courses_for_skills[skill] << course
        end
      end
    end
    

    limit = 10
    recommended_courses = []
    skill_index = 0
    
    # get list of recommended courses for each skill
    while recommended_courses.length < limit && !courses_for_skills.empty? do
      skill_index = skill_index % courses_for_skills.length
      current_skill = skills[skill_index]
      courses = courses_for_skills[current_skill]
      course = courses.shift
      if course.nil?
        courses_for_skills.delete(current_skill)
      else
        course["Skill"] = current_skill
        recommended_courses << course
      end
      skill_index += 1
    end

    return format(recommended_courses)

  end

  def self.format(courses)
    result = []
    courses.each do |course| 
     thumbnail = course["Thumbnails"].find { |t| !t["FullURL"].nil? }
      result << {
      :id => course["ID"],
      :url => course["URLs"]["www.lynda.com"],
      :title => course["Title"],
      :description => course["ShortDescription"],
      :thumbnail => thumbnail["FullURL"],
      :skill => course["Skill"]
    }
    end
    return result 
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
    rescue Timeout::Error, StandardError => e
      Rails.logger.error(e.message)
      json = []
    end

    json
  end


  def self.search_for_course(query)
    search_hash = {
      "q" => query, 
      "productType" => 2,
      "limit" =>  5,
      "filter.excludes" => "Facets,Results,Courses.Authors,Videos,PopularTerms,Articles,Playlists,Authors,Suggestions,Courses.Tags",
      "filter.values" => "Courses.Thumbnails[Width$gte$400,Width$lte$600]"
    }
    search_url = "/search?"
    search_url += search_hash.to_query

    LyndaApiController.get_json(search_url)
  end

  private
  
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
