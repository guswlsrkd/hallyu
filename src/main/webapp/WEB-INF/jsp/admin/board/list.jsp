<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${category.name} 게시글 관리</title>
    
    <!-- CSRF 토큰을 위한 meta 태그 추가 -->
   <%--  <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/> --%>
    <style>
        body { font-family: Arial, sans-serif; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .pagination { margin-top: 20px; text-align: center; }
        .pagination a { padding: 5px 10px; border: 1px solid #ddd; margin: 0 5px; text-decoration: none; color: #333; }
        .pagination a.active { background-color: #007bff; color: white; }
        .board-title-container { display: flex; align-items: center; gap: 10px; }
        .category-select { font-size: 1em; padding: 4px 8px; }
        .row-actions { display:flex; gap:6px; }
        .btn { cursor:pointer; padding:4px 8px; border:1px solid #ddd; background:#fff; border-radius:6px; }
        .btn:hover { background:#f2f2f2; }
        .btn-primary { background: #007bff; color: white; border-color: #007bff; }
    </style>
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

<div style="margin-top: 20px; text-align: right;">
   <%--  <a href="${pageContext.request.contextPath}/admin/board/${category.code}/write" class="btn btn-primary">새 글 작성</a> --%>
    <button type="button" class="btn btn-primary" onclick="openEditModal(null)">새 글 작성</button>
</div>

<table id = "postTable">
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
<div id="editPostModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.45); z-index:9999;">
    <div style="width:720px; max-width:calc(100% - 32px); background:#fff; border-radius:12px; margin:60px auto; box-shadow:0 20px 60px rgba(0,0,0,0.25);">
        <form id="editPostForm" onsubmit="submitEditForm(event)" enctype="multipart/form-data">
            <input type="hidden" id="edit-post-id" name="id" />
            <input type="hidden" id="edit-category-code" name="categoryCode" value="${category.code}" />
            <div style="padding:18px;">
                <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:15px;">
                    <h3 style="margin:0; font-size:18px;">게시글 수정</h3>
                    <button type="button" onclick="closeEditModal()" style="border:none;background:transparent;font-size:20px;line-height:1;cursor:pointer;">×</button>
                </div>

                <div style="margin-bottom: 10px;">
                    <label for="edit-title" style="display:block; margin-bottom: 4px;">제목</label>
                    <input type="text" id="edit-title" name="title" style="width:100%; padding:8px; border:1px solid #ddd; border-radius:4px;" required/>
                </div>
                <div>
                    <label for="edit-content" style="display:block; margin-bottom: 4px;">내용</label>
                    <textarea id="edit-content" name="content" rows="15" style="width:100%; padding:8px; border:1px solid #ddd; border-radius:4px;"></textarea>
                </div>
                <!-- 기존 첨부파일 목록 -->
                <div id="attachment-list-container" class="attachment-list" style="margin-top: 15px;">
                	<ul id="attachment-list"></ul>
                </div>
                <div>
                	<label for="edit-title" style="display:block; margin-bottom: 4px;">파일추가</label>
                	<button type="button" id="add-file-btn" class="btn" onclick="addFile()"  style="margin-top: 5px;">파일 추가</button>
                	<div id="file-container">
                    <!-- 파일 입력 필드가 여기에 추가됩니다. -->
                	</div>
                </div>
            </div>
            <div style="background:#f7f7f7; padding:12px 18px; border-top:1px solid #eee; display:flex; gap:8px; justify-content:flex-end; border-radius: 0 0 12px 12px;">
                <button type="button" class="btn" onclick="closeEditModal()">취소</button>
                <button type="submit" class="btn btn-primary">저장</button>
            </div>
        </form>
    </div>
</div>
<!-- ====== /게시글 수정 모달 ====== -->

<script>


    const C = '${pageContext.request.contextPath}';
	
	
    // 등록,수정 모달 열기
    async function openEditModal(postId) {
        try {
            const modalTitle = document.querySelector('#editPostModal h3');
            const editPostIdInput = document.getElementById('edit-post-id');
            const editTitleInput = document.getElementById('edit-title');
            const editContentInput = document.getElementById('edit-content');
            const attachmentList = document.getElementById('attachment-list');
            const attachmentContainer = document.getElementById('attachment-list-container');

            // 폼 초기화
            editPostIdInput.value = '';
            editTitleInput.value = '';
            editContentInput.value = '';
            attachmentList.innerHTML = ''; // 첨부파일 목록 초기화
            attachmentContainer.style.display = 'none'; // 첨부파일 컨테이너 숨기기

            if (postId != null) { // 수정 모드
                modalTitle.textContent = '게시글 수정';
	            const response = await fetch(C+'/admin/board/api/posts/'+postId);
	            if (!response.ok) throw new Error('게시글 정보를 불러오는 데 실패했습니다.');
	
	            
	            const data = await response.json();
	            const post = data.post;
                const attachments = data.attachments;
	
	            editPostIdInput.value = post.id;
	            editTitleInput.value = post.title;
	            editContentInput.value = post.content;
	            
	            if (attachments && attachments.length > 0) {
                    attachmentContainer.style.display = 'block';
                    attachments.forEach(file => {
                        const li = document.createElement('li');
                        li.innerHTML = `
                            <input type="checkbox" name="deleteFileIds" value="\${file.id}" id="del-file-\${file.id}">
                            <label for="del-file-\${file.id}">삭제</label>
                            &nbsp;
                            <a href="\${C}/file/download/\${file.id}">\${file.originalFilename}</a>
                        `;
                        attachmentList.appendChild(li);
                    });
                }
	            
        	} else { // 새 글 작성 모드
                modalTitle.textContent = '새 게시글 작성';
            }
            document.getElementById('editPostModal').style.display = 'block';
        } catch (error) {
            alert(error.message);
        }
    }

    // 수정 모달 닫기
    function closeEditModal() {
        document.getElementById('editPostModal').style.display = 'none';
    }

    // 수정 폼 제출
    async function submitEditForm(event) {
        event.preventDefault();
        const form = event.target;
        const postId = document.getElementById('edit-post-id').value; // postId는 id="edit-post-id"에서 가져옴
        const categoryCode = document.getElementById('edit-category-code').value; // categoryCode는 id="edit-category-code"에서 가져옴
        const formData = new FormData(form);
        
        const isNewPost = (postId === '' || postId === null); // postId가 없으면 새 글 작성
        let gubunUrl = "";

        // CSRF 토큰 정보 가져오기
       /*  const token = document.querySelector("meta[name='_csrf']").getAttribute("content");
        const headerName = document.querySelector("meta[name='_csrf_header']").getAttribute("content"); */

        try {
            if (isNewPost) {
                // 새 글 작성 시에는 categoryCode를 URL에 포함
                gubunUrl = C + "/admin/board/api/" + categoryCode + "/write";
                // FormData에 categoryCode를 추가 (컨트롤러의 @ModelAttribute AdminBoardPost post가 받을 수 있도록)
                formData.append('categoryCode', categoryCode);
            } else {
                // 게시글 수정 시에는 postId를 URL에 포함
                gubunUrl = C + "/admin/board/api/posts/" + postId;
            }

            // FormData를 URLSearchParams로 변환하여 body에 사용
            // fetch는 FormData를 직접 body로 사용할 수 있지만, URLSearchParams를 사용하면 Content-Type이 application/x-www-form-urlencoded로 설정됨
            const response = await fetch(gubunUrl, {
                 method: 'POST',
                 
                 //body: new URLSearchParams(formData)
                 // FormData 객체를 직접 body로 전송해야 파일이 포함됩니다.
                 body: formData
             });

            if (!response.ok) {
                 const errorData = await response.json().catch(() => ({ message: '저장에 실패했습니다.' }));
                 throw new Error(errorData.message);
             }

            // 게시글 수정 성공 시, 기존 행 업데이트 (새로고침 하므로 이 로직도 필요 없어짐)
             const rows = document.querySelectorAll('#postTable tbody tr');
             rows.forEach(row => {
                 const idCell = row.querySelector('.post-id');
                 if (idCell && idCell.textContent == postId) { // postId로 비교
                     // 제목 업데이트
                     row.querySelector('.post-title a').textContent = formData.get('title');
                     // 필요 시 다른 셀도 업데이트 (예: row.querySelector('.post-writer').textContent = updatedPost.writerId;)
                 }
                });
             alert('성공적으로 저장되었습니다.');
             location.reload(); // 페이지를 새로고침하여 변경사항을 반영
            closeEditModal(); // 모달 닫기
        } catch (error) {
            alert(error.message);
        } finally {
            // 로딩 인디케이터 종료 등
        }
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
                <button type="button" class="btn btn-danger remove-file-btn">삭제</button>
            </div>
        `;
    	document.getElementById('file-container').insertAdjacentHTML('beforeend', fileInputHtml);
    }
 
   
 
</script>

</body>
</html>
