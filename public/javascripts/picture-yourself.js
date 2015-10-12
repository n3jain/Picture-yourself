$(".picture-yourself").click(function(){
  var myProfile = $('.my_profile').val(),
    wannabeProfile = $('.wannabe_profile').val();

    $.ajax({url: "recommendations",
      data: { 
        "my_profile": myProfile,
        "wannabe_profile": wannabeProfile
    }, success: function(result){
      //debugger;
        $('.recommendations').text(result);
    }, error: function(error) {
      alert(error.statusText);
    }});
});