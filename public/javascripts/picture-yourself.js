$('.wannabe-profile').keypress(function(e){
  if (e.which == 13) {
    var myProfile = 'https://www.linkedin.com/in/yuchenmou', // hardcoding this for now
      wannabeProfile = $('.wannabe-profile').val(); // 'https://www.linkedin.com/in/marissamayer'

    // slide up header container
    $('.header-container').addClass('move-up');
    $('.wannabe-profile-container').slideUp('slow', function() {});
    $('.as-deliminator').slideUp('slow', function() {});

    $.ajax({
      url: 'recommendations',
      data: {
        "my_profile": myProfile,
        "wannabe_profile": wannabeProfile
      }, success: function (result) {
        renderCourses(result);
      }, error: function (error) {
        alert(error.statusText);
      }
    });
  }
});


var Course = React.createClass({
  getInitialState: function() {
    return {
      checked: false
    }
  },
  toggleChecked: function() {
    this.setState({ checked: !this.state.checked  });
  },
  render: function() {
    var checkMarkClassName = this.state.checked ? "checked" : "unchecked";
    return (
      <div className='course-item'>
        <div className={checkMarkClassName} onClick={this.toggleChecked}>✔</div>
        <a className='course-link' href={'https://www.lynda.com' + this.props.course.url} target='_blank'>
          <img className='course-thumbnail' src={this.props.course.thumbnail}/>
          <div className='course-info'>
            <div className='course-title'>{this.props.course.title}</div>
            <div className='course-description'>{this.props.course.description}</div>
            <div className='course-skill'>
              <span>Skill: </span>
              <span>{this.props.course.skill}</span>
            </div>
          </div>
        </a>
      </div>
    );
  }
});

var CourseList = React.createClass({
  render: function() {
    var courses = this.props.result.courses;
    var courseComponents = [];
    courses.forEach(function(course) {
      courseComponents.push(<Course key={course.title} course={course}/>);
    });
    return (
      <div className='courses-container'>
        <img className="profile-thumbnail" src={this.props.result.profile_pic1}/>
        <img className="profile-thumbnail" src={this.props.result.profile_pic2}/>
        {courseComponents}
      </div>
    );
  }
});

var renderCourses = function(result) {
  ReactDOM.render(<CourseList result={result}/>, document.getElementsByClassName("courses")[0]);
};
