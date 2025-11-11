<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


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
	<style>
		/* 게시판 테이블 스타일 */
		.board-table {
			width: 100%;
			border-collapse: collapse;
			margin-top: 20px;
			font-size: 14px;
			color: #333;
			table-layout: fixed; /* 테이블 너비를 고정하여 레이아웃 안정성 확보 */
		}
		.board-table th, .board-table td {
			padding: 12px 10px;
			text-align: center;
			border-bottom: 1px solid #e9ecef;
		}
		.board-table th {
			background-color: #f8f9fa;
			border-top: 2px solid #333;
			font-weight: 600;
		}
		/* 컬럼별 너비 지정 */
		.board-table th:nth-child(1) { width: 8%; } /* ID */
		.board-table th:nth-child(2) { width: auto; } /* 제목 */
		.board-table th:nth-child(3) { width: 12%; } /* 작성자 */
		.board-table th:nth-child(4) { width: 15%; } /* 등록일 */
		.board-table th:nth-child(5) { width: 10%; } /* 조회수 */

		.board-table td:nth-child(2) {
			text-align: left;
			/* 긴 제목은 ...으로 표시 */
			white-space: nowrap;
			overflow: hidden;
			text-overflow: ellipsis;
		}
		.board-table a {
			text-decoration: none;
			color: #333;
		}
		.board-table a:hover {
			text-decoration: underline;
		}
		.board-table tr:hover {
			background-color: #f5f5f5;
		}

		/* 페이지네이션 스타일 */
		.pagination {
			display: flex;
			justify-content: center;
			align-items: center;
			margin-top: 30px;
			gap: 10px;
		}
	</style>
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
    <h2>게시판 목록</h2>
    <table class="board-table">
        <thead>
        <tr>
            <th>ID</th>
            <th>제목</th>
            <th>작성자</th>
            <th>등록일</th>
            <th>조회수</th>
        </tr>
        </thead>

        <tbody>
        <c:forEach var="it" items="${list}">
            <tr>
                <td>${it.id}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/board/post/${it.id}">
                        ${it.title}
                    </a>
                </td>
                <td>${it.writer}</td>
                <td>
                    <fmt:formatDate value="${it.createdAt}" pattern="yyyy-MM-dd" />
                </td>
                <td>${it.viewCnt}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <div class="board-footer" style="margin-top: 16px; text-align: right;"> ${category.writeAuth}4444444444444444444
        <%-- 
            글쓰기 버튼 표시 조건:
            1. (관리자 전용 글쓰기) 게시판의 쓰기 권한(category.writeAuth)이 'ROLE_ADMIN'이고, 현재 사용자가 'ADMIN' 역할을 가졌을 때
            2. (사용자용 글쓰기) 게시판의 쓰기 권한이 'ROLE_USER'이고, 현재 사용자가 'USER' 역할을 가졌을 때 (로그인한 모든 사용자)
            3. (전체 글쓰기) 게시판의 쓰기 권한이 'ROLE_ANONYMOUS'일 때 (로그인 여부와 상관없이 항상 표시)
        --%>
        <%-- 
            수정된 조건:
            1. 현재 사용자가 'ADMIN' 역할을 가지고 있거나,
            2. 또는, 현재 사용자가 'USER' 역할을 가지고 있으면서 게시판의 쓰기 권한이 'ROLE_USER'일 때
        --%>
       <sec:authorize access="hasRole('ADMIN') or (hasRole('USER') and '${category.writeAuth}' == 'ROLE_USER')">
            <a href="${pageContext.request.contextPath}/board/${category.code}/write" class="btn btn-primary">글쓰기</a>1111
      </sec:authorize>
11111
    </div>

    <div class="pagination">
        <c:if test="${page > 1}">
            <a href="?cat=${cat}&page=${page - 1}">&lt; Prev</a>
        </c:if>

        <span>${page}</span>

        <c:if test="${list.size() == size}">
            <a href="?cat=${cat}&page=${page + 1}">Next &gt;</a>
        </c:if>
    </div>
     </div>
   </div>   
<%@ include file="/WEB-INF/jsp/_layout/footer.jspf" %>
</div>

</body>
</html>
