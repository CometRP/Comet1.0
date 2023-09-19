$(document).ready(function(){
    $(".container").hide();
    $(".info-box").hide();
    var current
    var pos
    var lastpos
    function print(param) { 
        console.log(param)
    }

    window.addEventListener("message", function(event){
        var data = event.data
        lastpos = data.lastpos
        $(".container").show()
        createButtons(data.data)
    });
    function createButtons(data) { 
        var len = data.length
        for (i=0; i < len; i++) {
            $(".spawn-points").append('<i class="fas fa-map-marker-alt" data-id=' + i + ' id="loc' + i + '"><div class="info-box" id="label' + i +'">' + data[i].label + '</div></i>');
            $(".spawn-points").find("[data-id="+i+"]").data("data", data[i]);
            $(".spawn-points").find("[data-id="+i+"]").data("coords", data[i].coords);
            $(".spawn-points").find("[data-id="+i+"]").data("id", i);
        }
    }

    $(document).on("mouseenter", ".fas", function(e){
        var th = $(this)
        $("#label"+th.data("id")).fadeIn(250);
        if (th.data("data").label != null) {
            document.getElementById("info").innerHTML = th.data("data").info
        }
    });
    $(document).on("mouseleave", ".fas", function(e){
        var th = $(this)
        if ("#label" + th.data("id") != "#label"+current) {
            $("#label"+th.data("id")).fadeOut(250);
        }
    });
    $(document).on("click", ".fas", function(e){
        var th = $(this)
        if (current != null) {
            $("#loc"+current).css("color", "rgb(0, 132, 255)");
            $("#loc"+current).css("font-size", "x-large");
            $("#label"+current).fadeOut(400);
        }
       $("#loc"+th.data("id")).css("color", "rgb(255, 255, 255)");
       $("#loc"+th.data("id")).css("font-size", "xx-large");
       current = th.data("id")
       pos = th.data("coords")
    });
    $(document).on("click", "#lastpos", function(e){
        if (current != null) {
            $("#loc"+current).css("color", "rgb(255, 252, 82)");
            $("#loc"+current).css("font-size", "x-large");
            $("#label"+current).fadeOut(400);
        }
    });

    $(document).on("click", ".play", function(e){
        if (document.getElementById("lastpos").checked) {
            pos = lastpos
        }
        if (pos != null) {
            $(".container").fadeOut(500)
            $.post('http://comet-spawn/spawn', JSON.stringify({coords: pos, id: current}));
            $('#info').hide()
        }
    });

    // $(".spawn-points").mouseenter(function () { 
    //     var th = $(this).data("id")
    //     print(th)
    //    $("#label"+th).show();
    // });
})

//