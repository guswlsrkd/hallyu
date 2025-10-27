<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page session="false" %>
<html lang="ko">
<head>
    <title>소방청 헬프데스크s</title>

    <!-- Required meta tags -->
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	
	<link rel="stylesheet" href="<c:url value='/assets/common/css/common.css'/>">
	<link rel="stylesheet" href="<c:url value='/assets/common/css/sub.css'/>">
	<link rel="stylesheet" href="<c:url value='/assets/common/css/xeicon.min.css'/>">
	<link rel="stylesheet" href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">  
	<link rel="stylesheet" href="http://cdn.jsdelivr.net/npm/xeicon@1.0.4/xeicon.min.css">  
    
	<script type="text/javascript" src="<c:url value='/assets/common/js/jquery-3.7.1.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/assets/common/js/common.js'/>"></script>
	

</head>

<body>
	
<nav class="skip">
<a href="#gnb">주 메뉴 바로가기</a>
<a href="#content">본문 바로가기</a>
</nav>		
	
<div id="wrap">
	
	<%@ include file="/WEB-INF/jsp/_layout/header.jspf" %>
	
	<div id="content_wrap">
		<div class="content">			
			<h3>집회정보</h3>
		
			<div class="sview_b">
				
				<!-- 좌 이미지 -->
				<div class="view_head">
					<figure>
							<img src="<c:url value='/assets/common/test.jpg'/>" alt="">
							<figcaption>인천시 남동구가 중소기업 해외시장 판로개척을 통해 K-뷰티 전파에 앞장선다. 인천시 남동구가 중소기업 해외시장 판로개척을 통해 K-뷰티 전파에 앞장선다.인천시 남동구가 중소기업 해외시장 판로개척을 통해 K-뷰티 전파에 앞장선다.</figcaption>
					</figure>
				</div>
				
				<!-- 우 내용 -->
				<div class="view_body">
					<div class="body_in">
						
						<h2>촛불행동(11차 촛불대행진)</h2>
						
						<dl class="writer_info">
							<dt>작성자</dt><dd class="name">홍길동</dd>
							<dt>작성일</dt><dd class="date">2024.11.05</dd>
						</dl>
					
						<ul class="location_info">
							<li>
								<span class="location">집회장소</span>서울 광화문
							</li>
							<li>
								<span class="schedule">집회일정</span><b>2024. 11. 05 13:00</b>
							</li>
						</ul>
						
						인천시 남동구가 중소기업 해외시장 판로개척을 통해 K-뷰티 전파에 앞장선다.<br>

						남동구는 인천테크노파크와 지역 중소기업의 해외시장 진출을 위해 5일 ㈜아주화장품을 포함한 15개 사(6개 화장품 제조업체)가 참여하는 베트남 시장개척단을 파견한다고 4일 밝혔다.<br>

						이번 시장개척단은 화장품 수출 규모가 나날이 증가하는 가운데 지역 중소기업의 경쟁력을 알리고 판로개척을 지원하기 위해 추진됐다.<br>

						중소벤처기업부가 최근 발표한 올해 3분기 중소기업 수출 동향을 보면 화장품 수출액은 17억 달러로, 10대 주요 수출 품목 중 전년 대비 증가 폭이 가장 컸다.<br>

						특히, 대기업 수출 증가율(3.3%)과 비교해 큰 증가세(26.7%)를 보이며, 국내 화장품 전체 수출액 중 중소기업 비중은 65%를 넘어섰다.<br>

						한국무역협회 인천지역본부의 9월 인천 수출입 동향 자료에서도 화장품 수출 규모는 전체 6위를 기록하며, 꾸준히 성장세를 나타내고 있다.

						<p class="source"><span><b>기사 출처</b> 티아이티소프트웨어 이대표</span></p>

						<div id="comment_wrap">
						<!-- 댓글 -->
							<div class="comment-write">
								<div class="comment_t">
									<label for="cmtContent" class="show-for-sr">댓글 내용입력</label>
									<textarea name="content" title="댓글 내용입력" class="" placeholder="권리침해, 욕설 및 특정 대상을 비하하는 내용을 게시할 경우 이용약관 및 관련법률에 의해 제재될 수 있습니다. 회원 로그인을 하시면 댓글 작성이 간편합니다."></textarea>
								</div>
								<div class="comment_b">
									<div class="num"><span>0</span> / 400</div> 
									<button title="닫기" >등록</button>
								</div>
							</div>
						<!-- 댓글 top-->
							<div class="comment_list_t">
								<div>댓글 <span>2</span></div>
								<div>
									<button class="hw_btn" >공감순</button>
									<button class="hw_btn is_active" >최신순</button>
									<button class="hw_btn" >오래된순</button>
								</div>	
							</div>
						<!-- 댓글  s -->
							<div class="cmt_w">
								<ul class="cmt_list">
									<!-- 댓 1-->
									<li class="cmt_b">
										<div class="cmt">
											<div class="writer_info">
												<div class="info"><p class="user_id">hong****</p><p class="time_info">15시간 전</p></div>
												<button class="user_btn"></button>
												<button class="layer_popup" ><!--style="display:none;"-->삭제</button>
											</div>
											<div class="cont">
												답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글
											</div>
											<div class="cmt_num"><button>답글 <b>2</b></button></div>
										</div>

										<!-- 댓댓 wrap -->
										<div class="cmt reply">

											<ul>
												<!-- 댓댓1 -->
												<li>
													<div class="writer_info">
														<div class="info"><p class="user_id">mos***</p><p class="time_info">10시간 전</p></div>
														<button class="user_btn"></button>
													</div>
													<div class="cont">
														답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글
													</div>
													<div class="cmt_num"><button>답글 <b>0</b></button></div>
												</li>
												<!-- 댓댓2 -->
												<li>
													<div class="writer_info">
														<div class="info"><p class="user_id">kim****</p><p class="time_info">13시간 전</p></div>
														<button class="user_btn"></button>
													</div>
													<div class="cont">
														답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글
													</div>
													<div class="cmt_num"><button>답글 <b>0</b></button></div>

													<!-- 댓댓글 쓰기 -->
													<div class="comment-write">
														<div class="comment_t">
															<label for="cmtContent" class="show-for-sr">댓글 내용입력</label>
															<textarea name="content" title="댓글 내용입력" class="" placeholder="권리침해, 욕설 및 특정 대상을 비하하는 내용을 게시할 경우 이용약관 및 관련법률에 의해 제재될 수 있습니다. 회원 로그인을 하시면 댓글 작성이 간편합니다."></textarea>
														</div>
														<div class="comment_b">
															<div class="num"><span>0</span> / 400</div> 
															<button title="닫기" >등록</button>
														</div>
													</div>


												</li>

											</ul>

										</div>
									</li>
									<li class="cmt_b">
										<div class="cmt">
											<div class="writer_info">
												<div class="info"><p class="user_id">hong****</p><p class="time_info">15시간 전</p></div>
												<button class="user_btn"></button>
											</div>
											<div class="cont">
												답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글답글
											</div>
											<div class="cmt_num"><button>답글 <b>0</b></button></div>
										</div>

									</li>
								</ul>  

							</div>	
						<!-- 댓글 list s -->
						</div>

						<div class="move_area">
							<ul>
								<li class="prev on">
									<a href="#">이전</a>
								</li>
								<li class="list"><a href="${pageContext.request.contextPath}/list" target="_self">목록으로</a></li>
								<li class="next on">
									<a href="#">다음</a>
								</li>
							</ul>
						</div>
						
					</div>
				</div>
			</div>
		
	</div>
	</div>
	
	
	<%@ include file="/WEB-INF/jsp/_layout/footer.jspf" %>

</div>
	
</body>
</html>