
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
	<link rel="stylesheet" href="<c:url value='/assets/common/css/board.css'/>">
    
	<script type="text/javascript" src="<c:url value='/assets/common/js/jquery-3.7.1.min.js'/>"></script>
	<%-- 스마트에디터 스크립트 추가 --%>
	<script type="text/javascript" src="<c:url value='/assets/smarteditor2/smarteditor2-2.10.0/package/dist/js/service/HuskyEZCreator.js'/>" charset="utf-8"></script>

	<script type="text/javascript" src="<c:url value='/assets/common/js/common.js'/>"></script>

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
                <textarea id="content" name="content" style="width:100%; height:400px; display:none;"></textarea>
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
	var oEditors = []; // 스마트에디터 객체를 담을 배열
	
	$(document).ready(function() {
		// 스마트에디터 초기화
		nhn.husky.EZCreator.createInIFrame({
			oAppRef: oEditors,
			elPlaceHolder: "content", // textarea의 id
			sSkinURI: "<c:url value='/assets/smarteditor2/smarteditor2-2.10.0/package/dist/SmartEditor2Skin.html'/>",
			htParams : {
				bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
				fOnBeforeUnload : function(){}
			}, 
			fCreator: "createSEditor2"
		});

	    // '파일 추가' 버튼 클릭 이벤트
	    $('#add-file-btn').click(function() {
	        var fileInputHtml = `
	            <div class="file-input-group">
	                <input type="file" name="files" class="form-control">
	                <button type="button" class="btn btn-danger remove-file-btn" style="border:none; background-color:transparent;"><i class="xi-close-circle-o"></i></button>
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

		// 폼 제출 이벤트 핸들러
        $('#writeForm').submit(function(event) {
            // 1. 에디터의 내용을 실제 textarea에 업데이트
            oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);

            // 2. 제목과 내용 유효성 검사
            var title = $("#title").val();
            var content = $("#content").val();

            // 스마트에디터에서 아무것도 입력하지 않으면 '<p>&nbsp;</p>' 와 같은 기본 태그가 남을 수 있으므로, 이를 제거하고 순수 텍스트만으로 비어있는지 확인합니다.
            var pureText = $('<div>').html(content).text().trim();

            if (title.trim() === "") {
                alert("제목을 입력해주세요.");
                $("#title").focus();
                event.preventDefault(); // 폼 제출 중단
                return;
            }

            if (pureText === "") {
                alert("내용을 입력해주세요.");
                oEditors.getById["content"].exec("FOCUS"); // 에디터에 포커스
                event.preventDefault(); // 폼 제출 중단
                return;
            }

            // 3. 사용자에게 저장 여부 확인
            if (!confirm('저장하시겠습니까?')) {
                event.preventDefault(); // '취소'를 누르면 폼 제출 중단
            }
        });
	}); // end of $(document).ready()
</script>
</html>