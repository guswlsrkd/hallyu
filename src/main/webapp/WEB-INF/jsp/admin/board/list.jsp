<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${category.name} 게시글 관리</title>

    <%-- 스마트에디터 스크립트 추가 --%>
    <script type="text/javascript" src="<c:url value='/assets/common/js/jquery-3.7.1.min.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/assets/smarteditor2/smarteditor2-2.10.0/package/dist/js/service/HuskyEZCreator.js'/>" charset="utf-8"></script>
    <%-- 게시판 CSS 추가 --%>
    <link rel="stylesheet" href="<c:url value='/assets/admin/css/board.css'/>">
    
    <!-- CSRF 토큰을 위한 meta 태그 추가 -->
   <%--  <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/> --%>
</head>
<body>
<%@ include file="/WEB-INF/jsp/admin/_layout/header.jspf" %>
<div class="board-title-container">
    <h2>${category.name} 게시글 관리</h2>
    <select class="category-select" onchange="location.href=this.value;">
        <c:forEach var="cat" items="${allCategories}">
            <option value="${pageContext.request.contextPath}/admin/board/${cat.code}" ${cat.code == category.code ? 'selected' : ''}>
                <c:forEach begin="1" end="${cat.depth}">&nbsp;&nbsp;</c:forEach>
                <c:if test="${cat.depth > 0}">└&nbsp;</c:if>
                <c:out value="${cat.name}" />
            </option>
        </c:forEach>
    </select>
</div>

<div class="top-actions">
   <%--  <a href="${pageContext.request.contextPath}/admin/board/${category.code}/write" class="btn btn-primary">새 글 작성</a> --%>
    <button type="button" class="btn btn-primary" onclick="openEditModal(null)">새 글 작성</button>
</div>

<table id="postTable" class="board-table">
    <thead>
    <tr>
        <th>ID</th>
        <th>제목</th>
        <th>작성자</th>
        <th>작성일</th>
        <th>조회수</th>
        <th>액션</th>
    </tr>
    </thead>
    <tbody>
    <c:if test="${empty posts}">
        <tr>
            <td colspan="5" style="text-align: center; padding: 40px;">등록된 게시글이 없습니다.</td>
        </tr>
    </c:if>
    <c:forEach var="post" items="${posts}"> <%-- AdminBoardPost 객체 사용 --%>
        <tr>
            <td class="post-id">${post.id}</td> <%-- ID 열 --%>
            <td class="post-title"><a href="${pageContext.request.contextPath}/admin/board/${category.code}/${post.id}"><c:out value="${post.title}" /></a></td>
            <td class="post-writer"><c:out value="${post.writerId}" /></td>
            <td><fmt:formatDate value="${post.createdAt}" pattern="yyyy-MM-dd HH:mm" /></td>
            <td>${post.viewCount}</td>
            <td>
                <div class="row-actions">
                    <button type="button" class="btn" onclick="openEditModal(${post.id})">수정</button>
                    <button type="button" class="btn" onclick="deletePost(${post.id})">삭제</button>
                </div>
            </td>
        </tr>
    </c:forEach>

    </tbody>
</table>

<div class="pagination">
    <c:if test="${currentPage > 1}">
        <a href="?page=${currentPage - 1}">&laquo;</a>
    </c:if>

    <c:forEach begin="1" end="${totalPages}" var="i">
        <a href="?page=${i}" class="${i == currentPage ? 'active' : ''}">${i}</a>
    </c:forEach>

    <c:if test="${currentPage < totalPages}">
        <a href="?page=${currentPage + 1}">&raquo;</a>
    </c:if>
</div>

<!-- ====== 게시글 수정 모달 ====== -->
<div id="editPostModal" class="modal-overlay">
    <div class="modal-dialog">
        <form id="editPostForm" onsubmit="submitEditForm(event)" enctype="multipart/form-data">
            <input type="hidden" id="edit-post-id" name="id" />
            <input type="hidden" id="edit-category-code" name="categoryCode" value="${category.code}" />
            <div class="modal-content-wrap">
                <div class="modal-header">
                    <h3 class="modal-title">게시글 수정</h3>
                    <button type="button" onclick="closeEditModal()" class="modal-close-btn">×</button>
                </div>

                <div class="form-group">
                    <label for="edit-title" class="form-label">제목</label>
                    <input type="text" id="edit-title" name="title" class="form-input" required/>
                </div>
                <div>
                    <label for="edit-content" class="form-label">내용</label>
                    <textarea id="edit-content" name="content" rows="15" class="form-textarea-hidden"></textarea>
                </div>
                <!-- 기존 첨부파일 목록 -->
                <div id="attachment-list-container" class="attachment-list-container">
                	<ul id="attachment-list"></ul>
                </div>
                <div>
                	<label class="form-label">파일추가</label>
                	<button type="button" id="add-file-btn" class="btn add-file-btn" onclick="addFile()">파일 추가</button>
                	<div id="file-container">
                    <!-- 파일 입력 필드가 여기에 추가됩니다. -->
                	</div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn" onclick="closeEditModal()">취소</button>
                <button type="submit" class="btn btn-primary">저장</button>
            </div>
        </form>
    </div>
</div>
<!-- ====== /게시글 수정 모달 ====== -->

<script>

    const C = '${pageContext.request.contextPath}';
    var oEditors = []; // 스마트에디터 객체를 담을 배열
    let isEditorLoaded = false; // 에디터 로딩 상태를 추적하는 플래그

    // HTML 태그를 제거하고 순수 텍스트만 반환하는 함수
    function getPureText(html) {
        return $('<div>').html(html).text().trim();
    }

    // 등록,수정 모달 열기
    async function openEditModal(postId) {
        // 1. 폼 내용을 먼저 초기화합니다.
        resetModalForm();

        // 2. 모달을 화면에 표시합니다.
        document.getElementById('editPostModal').style.display = 'block';

        // 3. 모달이 표시된 후, 스마트에디터를 생성합니다.
        nhn.husky.EZCreator.createInIFrame({
            oAppRef: oEditors,
            elPlaceHolder: "edit-content",
            sSkinURI: "<c:url value='/assets/smarteditor2/smarteditor2-2.10.0/package/dist/SmartEditor2Skin.html'/>",
            htParams: { bUseToolbar: true, bUseVerticalResizer: true, bUseModeChanger: true },
            fCreator: "createSEditor2",
            fOnAppLoad: async () => await fillModalData(postId) // 에디터 로딩 완료 후 데이터 채우기
        });
    }

    // 모달에 데이터를 채우는 함수 (에디터 로딩 후 호출)
    async function fillModalData(postId) {
        const modalTitle = document.querySelector('#editPostModal h3');
        const editPostIdInput = document.getElementById('edit-post-id');
        const editTitleInput = document.getElementById('edit-title');

        try {
            if (postId != null) { // 수정 모드
                modalTitle.textContent = '게시글 수정'; // 제목 변경
                const response = await fetch(C + '/admin/board/api/posts/' + postId);
                if (!response.ok) throw new Error('게시글 정보를 불러오는 데 실패했습니다.');

                const data = await response.json();
                const post = data.post;
                const attachments = data.attachments;

                editPostIdInput.value = post.id;
                editTitleInput.value = post.title;

                // 불필요한 태그가 추가되는 것을 방지하기 위해 내용을 미리 정리합니다.
                const cleanContent = (post.content || "").replace(/<p>(?:&nbsp;|\s)*<\/p>$/i, "");

                // fOnAppLoad 콜백에서 호출되므로, 에디터는 항상 로드된 상태입니다.
                oEditors.getById["edit-content"].exec("PASTE_HTML", [cleanContent]);

                const attachmentContainer = document.getElementById('attachment-list-container');
                const attachmentList = document.getElementById('attachment-list');
                if (attachments && attachments.length > 0) {
                    attachmentContainer.style.display = 'block';
                    attachments.forEach(file => {
                        const li = document.createElement('li');
                        li.innerHTML = `
                            <input type="checkbox" name="deleteFileIds" value="\${file.id}" id="del-file-\${file.id}">
                            <label for="del-file-\${file.id}">삭제</label>
                            &nbsp;
                            <a href="\${C}/board/download/attachment/\${file.id}">\${file.originalFilename}</a>
                        `;
                        attachmentList.appendChild(li);
                    });
                }
            } else { // 새 글 작성 모드
                modalTitle.textContent = '새 게시글 작성';
            }

        } catch (error) {
            alert(error.message);
        } finally {
            // 모드와 관계없이, 데이터 로딩이 끝나면 항상 제목 필드에 포커스를 줍니다.
            // 이는 스마트에디터의 비정상적인 포커스 동작을 회피하기 위한 가장 안정적인 방법입니다.
            editTitleInput.focus();
        }
    }

    // 모달 폼 초기화 함수
    function resetModalForm() {
        const modalTitle = document.querySelector('#editPostModal h3');
        const editPostIdInput = document.getElementById('edit-post-id');
        const editTitleInput = document.getElementById('edit-title');
        const attachmentList = document.getElementById('attachment-list');
        const attachmentContainer = document.getElementById('attachment-list-container');

        // 폼 초기화
        editPostIdInput.value = '';
        editTitleInput.value = '';
        attachmentList.innerHTML = '';
        attachmentContainer.style.display = 'none';
        document.getElementById('file-container').innerHTML = ''; // 새로 추가된 파일 목록 초기화

        // textarea를 감싸고 있는 부모 div의 내용을 비워서 에디터를 완전히 제거합니다.
        const editorParent = document.getElementById('edit-content').parentElement;
        editorParent.innerHTML = '<textarea id="edit-content" name="content" rows="15" class="form-textarea-hidden"></textarea>';
    }

    // 수정 모달 닫기
    function closeEditModal() {
        document.getElementById('editPostModal').style.display = 'none';
        // 모달을 닫을 때 에디터 관련 리소스를 정리합니다.
        // HuskyEZCreator는 공식적인 destroy 메소드를 제공하지 않으므로,
        // resetModalForm을 호출하여 DOM을 초기화하는 것으로 대체합니다.
        if (oEditors.length > 0) {
            oEditors.length = 0; // 에디터 객체 배열 초기화
        }
    }

    // 수정 폼 제출
    async function submitEditForm(event) {
        event.preventDefault();
        const form = event.target;

        // 1. 스마트에디터의 내용을 textarea에 업데이트
        oEditors.getById["edit-content"].exec("UPDATE_CONTENTS_FIELD", []);

        // 2. UPDATE_CONTENTS_FIELD 명령이 실행될 시간을 확보하기 위해 setTimeout을 사용합니다.
        setTimeout(async () => {
            const postId = document.getElementById('edit-post-id').value;
            const categoryCode = document.getElementById('edit-category-code').value;
            const formData = new FormData(form);

            // 3. 유효성 검사
            const title = formData.get('title').trim();
            const content = formData.get('content'); // 업데이트된 textarea의 값

            if (title === "") {
                alert("제목을 입력해주세요.");
                return;
            }

            if (getPureText(content) === "") {
                alert("내용을 입력해주세요.");
                oEditors.getById["edit-content"].exec("FOCUS");
                return;
            }

            const isNewPost = (postId === '' || postId === null);
            let gubunUrl = "";

            try {
                if (isNewPost) {
                    // 새 글 작성
                    gubunUrl = C + "/admin/board/api/" + categoryCode + "/write";
                    formData.append('categoryCode', categoryCode);
                } else {
                    // 게시글 수정
                    gubunUrl = C + "/admin/board/api/posts/" + postId;
                }

                const response = await fetch(gubunUrl, {
                    method: 'POST',
                    body: formData // FormData 객체를 직접 body로 전송해야 파일이 포함됩니다.
                });

                if (!response.ok) {
                    const errorData = await response.json().catch(() => ({ message: '저장에 실패했습니다.' }));
                    throw new Error(errorData.message);
                }

                alert('성공적으로 저장되었습니다.');
                location.reload(); // 페이지를 새로고침하여 변경사항을 반영
            } catch (error) {
                alert(error.message);
            }
        }, 0); // 0밀리초 지연으로도 충분합니다.
    }
    
 // 게시글 삭제 함수
    async function deletePost(postId) {
        if (confirm('정말로 이 글을 삭제하시겠습니까?')) {
            // CSRF 토큰 정보 가져오기
           /*  const token = document.querySelector("meta[name='_csrf']").getAttribute("content");
            const headerName = document.querySelector("meta[name='_csrf_header']").getAttribute("content"); */
            const categoryCode = document.getElementById('edit-category-code').value; // categoryCode는 id="edit-category-code"에서 가져옴
            try {
                const response = await fetch(C + '/admin/board/api/'+categoryCode+'/'+ postId + '/delete', {
                    method: 'POST'
                   /*  headers: {
                        [headerName]: token // CSRF 토큰 헤더 추가
                    } */
                });

                if (!response.ok) {
                    const errorData = await response.json().catch(() => ({ message: '삭제에 실패했습니다.' }));
                    throw new Error(errorData.message);
                }

                const data = await response.json();
                if (data.success) {
                    alert('성공적으로 삭제되었습니다.');
                    location.reload(); // 페이지를 새로고침하여 변경사항을 반영
                } else {
                    alert('삭제에 실패했습니다.');
                }
            } catch (error) {
                alert(error.message);
            } finally {
                // 로딩 인디케이터 종료 등
            }
        }
    }
 
   
    async function addFile() {
    	
    	var fileInputHtml = `
            <div class="file-input-group">
                <input type="file" name="files" class="form-control">
                <button type="button" class="btn remove-file-btn">삭제</button>
            </div>
        `;
    	document.getElementById('file-container').insertAdjacentHTML('beforeend', fileInputHtml);
    }
 
    // '삭제' 버튼 클릭 이벤트 (동적으로 생성된 요소에 대한 이벤트 위임)
    $('#file-container').on('click', '.remove-file-btn', function() {
        $(this).closest('.file-input-group').remove();
    });

 
</script>

</body>
</html>
