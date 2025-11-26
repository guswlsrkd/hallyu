<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<html lang="ko">
<head>
    <title>${post.title}</title>

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
        .post-view {
            width: 100%;
            max-width: 800px;
            margin: 0 auto;
        }
        .post-header {
            border-bottom: 2px solid #333;
            padding-bottom: 15px;
            margin-bottom: 20px;
        }
        .post-header h2 {
            margin: 0;
            font-size: 24px;
        }
        .post-meta {
            margin-top: 10px;
            font-size: 14px;
            color: #666;
        }
        .post-meta span {
            margin-right: 15px;
        }
        .post-content {
            padding: 20px 0;
            min-height: 300px;
            line-height: 1.8;
            border-bottom: 1px solid #eee;
        }
        .post-actions {
            display: flex;
            justify-content: flex-end; /* 버튼들을 오른쪽으로 정렬 */
            gap: 8px; /* 버튼들 사이의 간격 */
            margin-top: 20px;
        }
         .post-attachments { padding: 15px 0; border-bottom: 1px solid #eee; }
        .post-attachments h4 { margin: 0 0 10px 0; font-size: 16px; }
        .post-attachments ul { list-style: none; margin: 0; padding: 0; }
        .post-attachments li { margin-bottom: 5px; }
        .post-attachments li a { text-decoration: none; color: #007bff; }
        .post-attachments li a:hover { text-decoration: underline; }
        .post-attachments .file-size { font-size: 12px; color: #888; margin-left: 5px; }
        .post-attachments i { margin-right: 5px; }
    </style>
</head>
<body>
<div id="wrap">
<%@ include file="/WEB-INF/jsp/_layout/header.jspf" %>
	<div id="content_wrap">
	<div class="content">	
        <div class="post-view">
            <div class="post-header">
                <h2><c:out value="${post.title}" /></h2>
                <div class="post-meta">
                    <span><strong>작성자:</strong> <c:out value="${post.writer}" /></span>
                    <span><strong>작성일:</strong> <fmt:formatDate value="${post.createdAt}" pattern="yyyy-MM-dd HH:mm" /></span>
                    <span><strong>조회수:</strong> ${post.viewCnt}</span>
                </div>
            </div>

            <div class="post-content">
                ${post.content}
            </div>
            <c:if test="${not empty attachments}">
                <div class="post-attachments">
                    <h4>첨부파일</h4>
                    <ul>
                        <c:forEach var="file" items="${attachments}">
                            <li>
                                <i class="xi-paperclip"></i>
                                <a href="${pageContext.request.contextPath}/board/download/attachment/${file.id}">
                                    <c:out value="${file.originalFilename}"/>
                                </a>
                                <span class="file-size">(<fmt:formatNumber value="${file.fileSize / 1024}" maxFractionDigits="1"/> KB)</span>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>

            <div class="post-actions">
                <a href="${pageContext.request.contextPath}/board/${post.categoryCode}" class="btn">목록으로</a>
                <sec:authorize access="hasRole('ADMIN') or principal == '${post.writer}'">
                    <a href="${pageContext.request.contextPath}/board/post/${post.id}/edit" class="btn btn-secondary">수정</a>
                    <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/board/post/${post.id}/delete" style="display: inline;">
                        <button type="submit" class="btn btn-danger">삭제</button>
                    </form>
                </sec:authorize>
            </div>
        </div>
    </div>
    </div>
<%@ include file="/WEB-INF/jsp/_layout/footer.jspf" %>
</div>
</body>
<script>
    document.getElementById('deleteForm').addEventListener('submit', function(event) {
        // 폼의 기본 제출 동작을 막습니다.
        event.preventDefault();

        // 사용자에게 삭제 여부를 확인합니다.
        if (confirm('정말 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
            // '확인'을 누르면 폼을 제출합니다.
            this.submit();
        }
    });
</script>
</html>