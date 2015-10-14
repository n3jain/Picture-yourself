$(".go-btn").click(function(){
  //var myProfile = $('.my-profile').val(),
  //  wannabeProfile = $('.wannabe-profile').val();
  var myProfile = "https://www.linkedin.com/in/yuchenmou",
    wannabeProfile = "https://www.linkedin.com/in/sumanthkolar";

    $.ajax({url: "recommendations",
      data: { 
        "my_profile": myProfile,
        "wannabe_profile": wannabeProfile
    }, success: function(result){
        renderCourses(result.courses);
        //$('.recommendations').text(result.skills);
    }, error: function(error) {
      alert(error.statusText);
    }});
});

var Course = React.createClass({
  render: function() {
    return (
      <div className='course-item'>
        <a className='course-link' href={'https://www.lynda.com' + this.props.course.url} target='_blank'>
          <img className='course-thumbnail' src="https://media.licdn.com/mpr/mpr/shrinknp_200_200/p/1/005/08a/0de/230a5cc.jpg"/>
          <div className='course-title'>{this.props.course.title}</div>
        </a>
      </div>
    );
  }
});

var CourseList = React.createClass({
  render: function() {
    var courses = this.props.courses;
    var courseComponents = [];
    courses.forEach(function(course) {
      courseComponents.push(<Course key={course.title} course={course}/>);
    });
    return (
      <div className='courses-container'>
        {courseComponents}
      </div>
    );
  }
});

var renderCourses = function(courses) {
  ReactDOM.render(<CourseList courses={courses}/>, document.getElementsByClassName("courses")[0]);
};
