class SkillCourseMappingController < ApplicationController
  require 'open-uri'

  def recommended_courses
    # Get Delta of skills from related method
    skills1 = get_skills_for_profile(params[:my_profile])
    skills2 = get_skills_for_profile(params[:wannabe_profile])
    delta = skills2 - skills1
    render :json => delta.to_json
    # Invoke LyndaAPI to get list of courses for above skills
    # Expected course list
    #course_list = [{:id => 123,
    #                :thumbnail => 'https://cdn.lynda.com/courses/151544-635354833423615985_88x158_thumb.jpg',
    #                :url => 'http://www.lynda.com/Business-Skills-tutorials/Presentation-Fundamentals/151544-2.html',
    #                :title => 'Presentation Fundamentals',
    #}]
    #course_list
  end

  # Returns array of skills for a given LI profile
  def get_skills_for_profile(profile_url)
    html = Nokogiri::HTML(open(profile_url))
    html.css('section#skills > ul > li.skill > a > span').collect do |span|
      span.content
    end
  end

  # This is for testing the get_skills_for_profile method
  def test_get_skills_route
    render :json => get_skills_for_profile(params[:profile_url]).to_json
  end
end
