class SkillCourseMappingController < ApplicationController
  def courses(profile1, profile2)
    # Get Delta of skills from related method
    # Invoke LyndaAPI to get list of courses for above skills
    course_list = [{:id => 123,
                    :thumbnail => 'https://cdn.lynda.com/courses/151544-635354833423615985_88x158_thumb.jpg',
                    :url => 'http://www.lynda.com/Business-Skills-tutorials/Presentation-Fundamentals/151544-2.html',
                    :title => 'Presentation Fundamentals',
    }]
    course_list
  end
end
