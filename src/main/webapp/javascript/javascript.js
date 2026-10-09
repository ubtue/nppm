$(document).ready(function () {
    $(".select-wrapper").each(function () {
        const wrapper = $(this);

        wrapper.on("click", ".add-select", function () {
          const block = $(this).closest(".select-block");
          const clone = block.clone();
          clone.find("select").prop("selectedIndex", 0);
          wrapper.append(clone);
        });

        wrapper.on("click", ".remove-select", function () {
          const blocks = wrapper.find(".select-block");
          if (blocks.length > 1) {
            $(this).closest(".select-block").remove();
          }
        });
      });

    // Onfocus set white border to search field
	$('#search input').on('focus',function() {
		$('#search').css({"background": "#fff"});
	});

    // Onblur reset white border of search field
	$('#search input').on('blur', function() {
		$('#search').css({"background": "#e3e3e3"});
	});

    // Set menu fixed after page scrolled
    $(window).scroll(function() {
        var scroll = $(window).scrollTop();

        if (scroll >= 65) {
            $(".menu-wrap").addClass("menu-fixed");
        } else {
            $(".menu-wrap").removeClass("menu-fixed");
        }
    });

    // Extended Search
    $( '.search-button').on('click', function (e) {
        var id = $(this).data('id');
        $('#erweiterte-suche form > *').addClass('hide');
        $('#tabs li a').removeClass('current-search');
        $('.' + id).addClass('current-search');
        $('#' + id).removeClass('hide');
        $('#' + id + ' > *').removeClass('hide');
        e.preventDefault();
    });
  
    $("#anim1").on("click", function(e){
      var count = 3;
      $(".anim1").fadeIn();
      for(var i = 0; i < count; i++){
        $(".anim1").animate({ right: "+=5px" }, "slow" );
        $(".anim1").animate({ right: "-=5px" }, "slow" );    
      }
      $(".anim1").fadeOut();
      e.preventDefault();
    });
  

//        var speed = 700;
//        var times = 5;
//        var loop = setInterval(anim, 800);
//        function anim(){
//          times--;
//          if(times === 0){clearInterval(loop);}
//          $(".anim1").animate({ right: "+=5px" }, "slow" );
//          $(".anim1").animate({ right: "-=5px" }, "slow" );
//        }
//
//
////     Startseite: Some Animations
//    $("#anim1").on("click", function(e){
//      $(".anim1").show();
//      $(".anim1").fadeOut();
//      e.preventDefault();
//    });

    $("#anim1").on("click", function(e){
//      $('#search').css({"background": "#fff"});
      $("#search input").focus();
      e.preventDefault();
    });

    $("#personen-table table").css({"width":"auto"})


}); // end document ready function


