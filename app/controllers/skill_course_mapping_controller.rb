class SkillCourseMappingController < ApplicationController
  require 'open-uri'

  def recommended_courses
    # Get Delta of skills from related method
    hash1 = get_profile_skills_for_profile(params[:my_profile])
    hash2 = get_profile_skills_for_profile(params[:wannabe_profile])
    delta = hash2[:skills] - hash1[:skills]
    # only get courses for first 10 skills
    delta = delta.slice(0,10)
    render :json => {
      :skills => delta, 
      :profile_pic1 => hash1[:profile_pic], 
      :profile_pic2 => hash2[:profile_pic],
      :courses => LyndaApiController.search_courses(delta)
    }.to_json

    # Invoke LyndaAPI to get list of courses for above skills
    # Expected course list
    #course_list = [{:id => 123,
    #                :thumbnail => 'https://cdn.lynda.com/courses/151544-635354833423615985_88x158_thumb.jpg',
    #                :url => 'http://www.lynda.com/Business-Skills-tutorials/Presentation-Fundamentals/151544-2.html',
    #                :title => 'Presentation Fundamentals',
    #                :description => 'Some description'
    #}]
    #course_list
  end

  # Returns array of skills for a given LI profile
  def get_profile_skills_for_profile(profile_url)
    begin
      html = Nokogiri::HTML(open(profile_url, :read_timeout => 10))
    rescue Timeout::Error
      return  {:error => 'Timout!'}
    end
    # file = File.open('foo.log', File::WRONLY | File::APPEND | File::CREAT)
    # # To create new (and to remove old) logfile, add File::CREAT like:
    # # file = File.open('foo.log', File::WRONLY | File::APPEND | File::CREAT)
    # logger = Logger.new(file)
    # logger.info("[NOKOGIRI RESULT]:" + html)
    skills = html.css('section#skills > ul > li.skill > a > span').collect do |span|
      span.content
    end
    if skills.empty?
      skills = html.css('div#profile-skills > ul > li > span > span> a').collect do |a|
        a.content
      end
    end

    profile_pic = html.css('div.profile-picture > a > img').collect do |img|
      img['data-delayed-url']
    end
    if profile_pic.empty? || profile_pic.first.nil?
      profile_pic = html.css('div.profile-picture > a > img').collect do |img|
        img['src']
      end
    end

    {:skills => skills, :profile_pic => profile_pic.first}
  end

  def get_profile_pics(profile_url)

  end

  # This is for testing the get_skills_for_profile method
  def test_get_skills_route
    render :json => get_profile_skills_for_profile("https://www.linkedin.com/in/marissamayer").to_json
  end
end
