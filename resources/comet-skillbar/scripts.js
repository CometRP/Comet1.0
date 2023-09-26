$(document).ready(function(){
  
    var documentWidth = document.documentElement.clientWidth;
    var documentHeight = document.documentElement.clientHeight;
    var curTask = 0;
    var processed = []
    var percent = 0;
  
    document.onkeydown = function (data) {
        // 69 = E btw lol rofl heh 
        if (data.which == 69) {
          closeMain()
          $.post('https://comet-skillbar/taskEnd', JSON.stringify({taskResult: percent}));
        }
    }
  
  
    function openMain() {
      $(".divwrap").fadeIn(10);
    }
  
    function closeMain() {
      $(".divwrap").css("display", "none");
    }  
  
    window.addEventListener('message', function(event){
  
      var item = event.data;
      if(item.runProgress === true) {
        percent = 0;
        openMain();
        $('#progress-bar').css("width","0%");
        $('.skillprogress').css("left",item.chance + "%")
        $('.skillprogress').css("width",item.skillGap + "%");
      }
  
      if(item.runUpdate === true) {
        percent = item.Length
        $('#progress-bar').css("width",item.Length + "%");
  
        if (item.Length < (item.chance + item.skillGap) && item.Length > (item.chance)) {
          $('.skillprogress').css("background-color","rgba(0, 255, 0,1)");
  
        } else {
          $('.skillprogress').css("background-color","rgba(50, 205, 50,1)");
        }
  
      }
  
      if(item.closeFail === true) {
        closeMain()
        $.post('https://comet-skillbar/taskCancel', JSON.stringify({tasknum: curTask}));
      }
  
      if(item.closeProgress === true) {
        closeMain();
      }
  
    });
  
  });