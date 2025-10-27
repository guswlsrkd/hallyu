
	/* Header 카테고리 마우스오버 */
	$(document).ready(function(){
		var max_h=0; // 최대 높이 구하기
		$(".gnb .sub-menu ul").each(function(){
			var h = parseInt($(this).css("height"));
			if(max_h<h){ max_h = h; }
		});
		// 카테고리
		$(".gnb ul").mouseover(function(){
			$(".gnb").addClass("active");
			$(".sub-menu").css({height:max_h});
		});
		$(".gnb ul").mouseleave(function(){
			$(".gnb").removeClass("active");
			$(".sub-menu").css({height:0});
		});
		$(".gnb a").click(function(){
			$(".gnb").removeClass("active");
			$(".sub-menu").css({height:0});
		});

		// 로그인전/후 말풍선 메뉴
		$(".gnb-user").click(function(){
			event.preventDefault();
			$(this).next(".tnb-menu").toggleClass("active");	
		});

		//전체메뉴
		$(".gnb-menu").click(function(){
			event.preventDefault();
			$(".all-menu-wrap").addClass("active");
			$("body").css("overflow-y", "hidden");
			$(".tnb-menu").removeClass("active");
		});
		$(".gnb-close").click(function(){
			event.preventDefault();
			$(".all-menu-wrap").removeClass("active");
			$("body").css("overflow-y", "visible");
			$(".tnb-menu").removeClass("active");
		});
		$(".all-menu-wrap h5").click(function(){
			if ($(window).width() < 900) {
				var isopened = false;
				if ($(this).hasClass("active")) { isopened = true; };
				$(".all-menu-wrap h5").removeClass("active");
				$(".depth-toggle").removeClass("active");				
				if (!isopened){
					$(this).addClass("active")
					$(this).next(".depth-toggle").addClass("active");
				} else {
					$(this).removeClass("active");
					$(this).next(".depth-toggle").removeClass("active");
				}
			} else {
				$(".all-menu-wrap h5").removeClass("active");
				$(".depth-toggle").removeClass("active");
				$(this).addClass("active").next(".depth-toggle").addClass("active");
			}
		});
		/*
		$(".all-menu-wrap h5").click(function(){
			$(this).toggleClass("active");
			$(this).next(".depth-toggle").toggleClass("active");
		});
		*/

		$(".depth-toggle .tlt").click(function(){
			$(this).parent("ul").toggleClass("active");
		});

		// 바디클릭시 말풍선 메뉴 닫기
		$('body').on('click', function(e){
			var $popArea = $(e.target).hasClass('gnb-user') 
			if ( !$popArea ) {
				$('.tnb-menu').removeClass('active');
			}
		});	

	});
