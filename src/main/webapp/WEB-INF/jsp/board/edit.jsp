<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html lang="ko">
<head>
    <title>글수정 - ${post.title}</title>

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
        <h2>글수정</h2>

        <form id="editForm" class="edit-form" method="post" action="${pageContext.request.contextPath}/board/post/${post.id}/edit" enctype="multipart/form-data">   
            <div class="form-group">
                <label for="title">제목</label>
                <input type="text" id="title" name="title" value="${post.title}" required>
            </div>
            <div class="form-group">
                <label for="content">내용</label>
                <%-- 기존 내용을 textarea에 출력합니다. --%>
                <textarea id="content" name="content" style="width:100%; height:400px; display:none;"><c:out value="${post.content}" escapeXml="false"/></textarea>
            </div>
            <div class="form-group">
                <label>첨부파일</label>
                <div id="existing-files">
                    <c:forEach var="file" items="${attachments}">
                        <div class="existing-file" id="file-${file.id}">
                            <span>${file.originalFilename}</span>
                            <button type="button" class="btn btn-danger remove-existing-file-btn" data-file-id="${file.id}" style="border:none; background-color:transparent;"><i class="xi-close-circle-o"></i></button>
                        </div>
                    </c:forEach>
                </div>
                <div id="file-container">
                    <!-- 새 파일 입력 필드가 여기에 추가됩니다. -->
                </div>
                 <%-- 숨겨진 이미지 업로드용 input --%>
                <input type="file" id="image-uploader-input" style="display:none;" accept="image/*"/>
                <!-- <button type="button" id="add-image-btn" class="btn" style="margin-top: 5px;">본문 이미지 추가</button> -->
                <button type="button" id="add-file-btn" class="btn" style="margin-top: 5px;">파일 추가</button>
            </div>
            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/board/post/${post.id}" class="btn">취소</a>
                <button type="submit" class="btn btn-primary">수정</button>
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
				bUseToolbar : true,
				bUseVerticalResizer : true,
				bUseModeChanger : true,
				fOnBeforeUnload : function(){}
			},
			/* fOnAppLoad : function(){
				// '사진' 버튼 클릭 시, 우리가 만든 팝업창을 띄웁니다.
				oEditors.getById["content"].exec("ADD_APP_PROPERTY", [
					"photo_uploader", 
					function(){
						var sUrl = "<c:url value='/assets/smarteditor2/popup/photo_uploader.jsp'/>";
						oEditors.getById["content"].exec("SE_TOGGLE_IMAGE_URL_LAYER", [sUrl]);
					}
				]);
			},  */
			fCreator: "createSEditor2"
		});

	    // '파일 추가' 버튼
	    $('#add-file-btn').click(function() {
	        var fileInputHtml = `<div class="file-input-group"><input type="file" name="files" class="form-control"><button type="button" class="btn btn-danger remove-file-btn" style="border:none; background-color:transparent;"><i class="xi-close-circle-o"></i></button></div>`;
	        $('#file-container').append(fileInputHtml);
	    });

	    // 새 첨부파일 '삭제' 버튼
	    $('#file-container').on('click', '.remove-file-btn', function() {
	        $(this).closest('.file-input-group').remove();
	    });

        // 기존 첨부파일 '삭제' 버튼
        $('.remove-existing-file-btn').click(function() {
            var fileId = $(this).data('file-id');
            // 숨겨진 input을 추가하여 서버에 삭제할 파일 ID를 전송
            $('#editForm').append('<input type="hidden" name="deleteFileIds" value="' + fileId + '">');
            // 화면에서 해당 파일 항목을 숨김
            $('#file-' + fileId).hide();
        });

        // '본문 이미지 추가' 버튼 클릭 이벤트
        $('#add-image-btn').click(function() {
            // 숨겨진 파일 input을 클릭합니다.
            $('#image-uploader-input').click();
        });

        // 숨겨진 파일 input의 내용이 변경되었을 때 (파일이 선택되었을 때)
        $('#image-uploader-input').on('change', function() {
            var file = this.files[0];
            if (!file) {
                return;
            }

            var formData = new FormData();
            formData.append('upload', file);

            // AJAX를 통해 서버로 이미지 전송
            $.ajax({
                url: '<c:url value="/board/imageUpload"/>',
                type: 'POST',
                data: formData,
                processData: false, // FormData를 사용할 때는 필수
                contentType: false, // FormData를 사용할 때는 필수
                success: function(response) {
                    // 서버로부터 받은 이미지 URL을 에디터에 삽입
                    var imageUrl = JSON.parse(response).url;
                    var imgTag = "<img src='" + imageUrl + "' style='max-width:100%;'>";
                    oEditors.getById["content"].exec("PASTE_HTML", [imgTag]);
                },
                error: function() {
                    alert('이미지 업로드에 실패했습니다.');
                }
            });
        });

		// 폼 제출 이벤트 핸들러
        $('#editForm').submit(function(event) {
            // 1. 에디터의 내용을 실제 textarea에 업데이트
            oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);

            if (!confirm('수정하시겠습니까?')) {
                event.preventDefault();
            }
        });
	});
</script>
</html>