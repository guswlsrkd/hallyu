
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html lang="ko">
<head>
    <title>글쓰기 - ${category.name}</title>

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
        .write-form {
            width: 100%;
            max-width: 800px;
            margin: 0 auto;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input[type="text"],
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .form-group textarea {
            height: 300px;
            resize: vertical;
        }
        .form-actions {
            text-align: right;
            margin-top: 20px;
        }
        .file-input-group {
            display: flex;
            align-items: center;
            margin-bottom: 5px;
        }
        .file-input-group input {
            flex-grow: 1;
        }
        .file-input-group button {
            margin-left: 8px;
            flex-shrink: 0;
        }
    </style>
</head>
<body>
<div id="wrap">
<%@ include file="/WEB-INF/jsp/_layout/header.jspf" %>
	<div id="content_wrap">
	<div class="content">	
        <h2>글쓰기: ${category.name}</h2>

       
         <form id="writeForm" class="write-form" method="post" action="${pageContext.request.contextPath}/board/${category.code}/write" enctype="multipart/form-data">   
            <input type="hidden" name="code" value="${category.code}">
            <div class="form-group">
                <label for="title">제목</label>
                <input type="text" id="title" name="title" required>
            </div>
            <div class="form-group">
                <label for="content">내용</label>
                <textarea id="content" name="content" required></textarea>
            </div>
             <div class="form-group">
                <label>첨부파일</label>
                <div id="file-container">
                    <!-- 파일 입력 필드가 여기에 추가됩니다. -->
                </div>
                <button type="button" id="add-file-btn" class="btn" style="margin-top: 5px;">파일 추가</button>
            </div>
            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/board/${category.code}" class="btn">취소</a>
                <button type="submit" class="btn btn-primary">저장</button>
            </div>
        </form>
    </div>
    </div>
<%@ include file="/WEB-INF/jsp/_layout/footer.jspf" %>
</div>
</body>
<script>

	$(document).ready(function() {
	    // '파일 추가' 버튼 클릭 이벤트
	    $('#add-file-btn').click(function() {
	        var fileInputHtml = `
	            <div class="file-input-group">
	                <input type="file" name="files" class="form-control">
	                <button type="button" class="btn btn-danger remove-file-btn">삭제</button>
	            </div>
	        `;
	        $('#file-container').append(fileInputHtml);
	    });
	
	    // '삭제' 버튼 클릭 이벤트 (동적으로 생성된 요소에 대한 이벤트 위임)
	    $('#file-container').on('click', '.remove-file-btn', function() {
	        $(this).closest('.file-input-group').remove();
	    });
	
	    // 페이지 로드 시 파일 입력 필드 하나를 기본으로 추가
	    $('#add-file-btn').click();
	});
    document.getElementById('writeForm').addEventListener('submit', function(event) {
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