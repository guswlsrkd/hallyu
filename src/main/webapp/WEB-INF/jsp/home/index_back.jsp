<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page session="false" %>
<html lang="ko">
<head>
    <title>소방청 헬프데스크</title>

    <!-- Required meta tags -->
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<link rel="stylesheet" href="<c:url value='/assets/common/css/common.css'/>">
	<link rel="stylesheet" href="<c:url value='/assets/common/css/xeicon.min.css'/>">
	<link rel="stylesheet" href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">  
    
	<script type="text/javascript" src="<c:url value='/assets/common/js/jquery-3.7.1.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/assets/common/js/common.js'/>"></script>
	
</head>

<body>
<nav class="skip">
<a href="#gnb">주 메뉴 바로가기</a>
<a href="#content">본문 바로가기</a>
</nav>		
	
<div id="wrap">

	<header id="header">
		<div class="header-inner">
			<h1 class="logo"><a href="index.html">대모임</a></h1>	
			<div class="gnb">
				<ul>
					<li><a href="${pageContext.request.contextPath}/list">집회 정보</a></li>
					<li><a href="#">집회 기사</a></li>
					<li class="v_r"><a href="#"><span>주의사항</span></a></li>
				</ul>
			</div>
			<div class="tnb">
				<a href="" class="gnb-menu"><span>전체메뉴</span></a>

				<!-- 전체메뉴 -->
				<div class="all-menu-wrap">
					<div class="all-menu-inner">

						<div class="all-menu-head">
							<div class="logo"><a href="index.html">대모임</a></div>
							<div class="right"><a href="#" class=" gnb-close"><span>전체메뉴</span></a></div>
						</div>
						<div class="all-menu-body">
							<a href="sub01.html">집회 정보</a>
							<a href="#">집회 기사</a>
							<a href="#" class="v_r">주의사항</a>
						</div>
					</div>
				</div>
			<!-- //전체메뉴 -->
			</div>
		</div>
	</header>
	
	<div id="content_wrap">
		<div class="content">			
			<ul>
				<li class="l_list">
					<h3>집회 정보</h3>
					<div class="l_set">
						<dl>
							<dt class="title "><a href="${pageContext.request.contextPath}/view" target="" class="omission_2"><span>버스서 혼자 넘어진 승객 "장애 생겼으니 2억 달라"…4년 뒤 판결 결과는</span></a></dt>
							<dd class="cont omission_3">
								세계 최고 장수 국가인 일본 도쿄에는 1971년 도쿄도 정부가 설립한 일본 최초의 노화·장수 연구소인 도쿄도립 건강장수연구소가 있다. 이 연구소는 의학 연구 성과를 분석해 효과가 입증된 것들만 엄선하여 ‘건강 장수 가이드라인’ 12가지 수칙을 제시했다.
							</dd>
						</dl>
					</div>
					<div class="l_set">
						<dl>
							<dt class="title"><a href="${pageContext.request.contextPath}/view" target="" class="omission_2"><span>"앞머리 헤어라인엔..." 탈모 부위 따라 먹는 약 알려 드립니다 [이러면 낫는다]</span></a></dt>
							<dd class="cont omission_3">
								조선일보 의학 전문 유튜브 콘텐츠 ‘이러면 낫는다’가 29일 현대 의학이 아직 해결하지 못한 난제인 ‘탈모’ 편을 공개했다. 국내 탈모 치료의 명의로 꼽히는 권오상 서울대병원 피부과 교수가 출연해 탈모의 증상과 원인, 치료 등에 대해 자세히 소개했다.
							</dd>
						</dl>
					</div>
					<div class="l_set">
						<dl>
							<dt class="title"><a href="#" target="" class="omission_2"><span>혼자 운동하기운동하기운동하기운동하기운동하기운동하기 vs 어울려 식사하기. 건강에 더 좋은 것은? 혼자 운동하기 vs 어울려 식사하기. 건강에 더 좋은 것은?</span></a></dt>
							<dd class="cont omission_3">주말마다 한두 번씩 하는 강도 높은 운동이 규칙적으로 자주 운동하는 것만큼이나 인지기능에 효과적이라는 연구 결과가 나왔다.</dd>
						</dl>
					</div>
				</li>
				<li class="r_photo">
					<h3>집회 기사</h3>
					<div class="p_set">
						<img src="assets/common/test.jpg" alt="">
						<dl>
							<dt class="title"><a href="#" target="" class="omission_2"><span>자택 거주 장기요양 수급자, 낙상 예방 시설 등 100만원 내 시공 지원 [알아두면 쓸데 있는 건강 정보]</span></a></dt>
							<dd class="cont omission_3">
								뱅크시(Banksy)는 영국에서 가명으로 활동하는 미술가 겸 그라피티 아티스트다. 그라피티는 래커 스프레이, 페인트 등을 이용해 공공장소에 그림을 그리거나 낙서를 새기는 행위를 말한다. 대개 남의 건물에 무명으로 허락 없이 하고, 사회적 메시지를 내기도 한다. 그라피티(graffiti) 단어 자체는 이탈리아어로 그냥 낙서라는 뜻이다.
							</dd>
							<dd class="source"><span>출처</span></dd>
						</dl>
					</div>
				</li>
			</ul>
		</div>	
	</div>

	<footer id="footer"><p class="copyright">Copyright © All Rights Reserved 2024.</p></footer>

</div>



</body>
</html>