<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html lang="ko">
<head>
    <title>글 수정 - ${post.title}</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="<c:url value='/assets/common/css/common.css'/>">
    <link rel="stylesheet" href="<c:url value='/assets/common/css/xeicon.min.css'/>">
    <link rel="stylesheet" href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
    <script type="text/javascript" src="<c:url value='/assets/common/js/jquery-3.7.1.min.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/assets/common/js/common.js'/>"></script>
    <style>
        .write-form { width: 100%; max-width: 800px; margin: 0 auto; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input[type="text"], .form-group textarea {
            width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;
        }
        .form-group textarea { height: 300px; resize: vertical; }
        .form-actions {
            display: flex;
            justify-content: flex-end; /* 버튼들을 오른쪽으로 정렬 */
            gap: 8px; /* 버튼들 사이의 간격 */
            margin-top: 20px;
        }
    </style>
</head>
<body>
<div id="wrap">
<%@ include file="/WEB-INF/jsp/_layout/header.jspf" %>
    <div id="content_wrap">
    <div class="content">
        <h2>글 수정</h2>
        <form id="editForm" class="write-form" method="post" action="${pageContext.request.contextPath}/board/post/${post.id}/edit">
            <div class="form-group">
                <label for="title">제목</label>
                <input type="text" id="title" name="title" value="<c:out value='${post.title}'/>" required>
            </div>
            <div class="form-group">
                <label for="content">내용</label>
                <textarea id="content" name="content" required><c:out value='${post.content}'/></textarea>
            </div>
            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/board/post/${post.id}" class="btn">취소</a>
                <button type="submit" class="btn btn-primary">저장</button>
            </div>
        </form>
    </div>
    </div>
<%@ include file="/WEB-INF/jsp/_layout/footer.jspf" %>
</div>
</body>
<script>
    document.getElementById('editForm').addEventListener('submit', function(event) {
        // 폼의 기본 제출 동작을 막습니다.
        event.preventDefault();

        // 사용자에게 저장 여부를 확인합니다.
        if (confirm('저장하시겠습니까?')) {
            // '확인'을 누르면 폼을 제출합니다.
            this.submit();
        }
    });
</script>
</html>