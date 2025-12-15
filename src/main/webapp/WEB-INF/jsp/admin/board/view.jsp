<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <!-- CSRF 메타 태그 추가 -->
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>게시글 상세보기</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { width: 100%; max-width: 960px; margin: 0 auto; }
        .post-header { border-bottom: 2px solid #333; padding-bottom: 10px; margin-bottom: 20px; }
        .post-title { font-size: 24px; margin: 0; }
        .post-meta { font-size: 14px; color: #666; margin-top: 10px; }
        .post-meta span { margin-right: 15px; }
        .post-content { min-height: 200px; padding: 20px 0; border-bottom: 1px solid #ddd; line-height: 1.6; }
        .attachment-section { padding: 20px 0; border-bottom: 1px solid #ddd; }
        .attachment-section h4 { margin-top: 0; }
        .attachment-list li { list-style: none; margin-bottom: 5px; }
        .button-container { text-align: right; margin-top: 20px; }
        .btn { display: inline-block; cursor: pointer; padding: 8px 16px; border: 1px solid #ddd; background: #fff; border-radius: 6px; text-decoration: none; color: #333; }
        .btn:hover { background: #f2f2f2; }
        .btn-primary { background: #007bff; color: white; border-color: #007bff; }
        .btn-danger { background: #dc3545; color: white; border-color: #dc3545; }
         .comments-area { padding: 20px 0; margin-top: 20px; border-top: 1px solid #eee; }
        .comments-area h3 { margin: 0 0 15px 0; font-size: 18px; }
        .comment { border-bottom: 1px solid #eee; padding: 15px 0; }
        .comment-meta { font-size: 13px; color: #666; margin-bottom: 5px; }
        .reply { margin-left: 40px; border-left: 2px solid #ddd; padding-left: 15px; }
        .reply-form { display: none; margin-top: 10px; }
        .comment-form textarea { width: 100%; height: 80px; padding: 10px; border: 1px solid #ddd; box-sizing: border-box; }
    </style>
    <!-- jQuery 로드 -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<%@ include file="/WEB-INF/jsp/admin/_layout/header.jspf" %>

<div class="container">
    <h2>${category.name} 게시글 상세보기</h2>

    <div class="post-header">
        <h1 class="post-title"><c:out value="${post.title}" /></h1>
        <div class="post-meta">
            <span><strong>작성자:</strong> <c:out value="${post.writerId}" /></span>
            <span><strong>작성일:</strong> <fmt:formatDate value="${post.createdAt}" pattern="yyyy-MM-dd HH:mm" /></span>
            <span><strong>조회수:</strong> ${post.viewCount}</span>
        </div>
    </div>

    <div class="post-content">
        ${post.content}
    </div>

    <c:if test="${not empty attachments}">
        <div class="attachment-section">
            <h4>첨부파일</h4>
            <ul class="attachment-list">
                <c:forEach var="file" items="${attachments}">
                    <li>
                        <a href="${pageContext.request.contextPath}/board/download/attachment/${file.id}">${file.originalFilename}</a>
                        (<fmt:formatNumber value="${file.fileSize / 1024}" maxFractionDigits="2" /> KB)
                    </li>
                </c:forEach>
            </ul>
        </div>
    </c:if>
    
    <c:if test="${category['use_comments'] == 'Y'}">
                <div class="comments-area">
                    <h3>댓글</h3>
                    <div id="commentList">
                        <c:choose>
                            <c:when test="${not empty comments}">
                                <c:forEach var="comment" items="${comments}">
                                    <%-- 원 댓글 + 답글 그룹 --%>
                                    <div class="comment-wrapper" id="comment-wrapper-${comment.id}">
                                        <%-- 원 댓글 --%>
                                        <div class="comment" id="comment-${comment.id}">
                                            <div class="comment-meta">
                                                <strong><c:out value="${comment.writerId}"/></strong> | <fmt:formatDate value="${comment.createdAt}" type="both" pattern="yyyy-MM-dd HH:mm"/>
                                                <sec:authorize access="isAuthenticated()">
                                                    <div style="float: right; font-size: 12px; display: inline-flex; gap: 8px;">
                                                        <button type="button" onclick="toggleReplyForm(${comment.id}, '${comment.writerId}')" style="background: none; border: none; color: #6c757d; cursor: pointer; padding: 0;">답글</button>
                                                        <c:if test="${pageContext.request.userPrincipal.name == comment.writerId or pageContext.request.isUserInRole('ROLE_ADMIN')}">
                                                            <button type="button" class="btn-comment-edit" data-comment-id="${comment.id}" style="background: none; border: none; color: #007bff; cursor: pointer; padding: 0;">수정</button>
                                                            <button type="button" onclick="deleteComment(${comment.id})" style="background: none; border: none; color: #dc3545; cursor: pointer; padding: 0;">삭제</button>
                                                        </c:if>
                                                    </div>
                                                </sec:authorize>
                                            </div>
                                            <p style="margin: 5px 0;"><c:out value="${comment.content}"/></p>
                                        </div>

                                        <%-- 답글 목록 --%>
                                        <div class="reply" id="reply-list-${comment.id}">
                                            <c:if test="${not empty comment.replies}">
                                                <c:forEach var="reply" items="${comment.replies}">
                                                    <div class="comment" id="comment-${reply.id}">
                                                        <div class="comment-meta">
                                                            <strong><c:out value="${reply.writerId}"/></strong> | <fmt:formatDate value="${reply.createdAt}" type="both" pattern="yyyy-MM-dd HH:mm"/>
                                                            <sec:authorize access="isAuthenticated()">
                                                                <div style="float: right; font-size: 12px; display: inline-flex; gap: 8px;">
                                                                    <button type="button" onclick="toggleReplyForm(${comment.id}, '${reply.writerId}')" style="background: none; border: none; color: #6c757d; cursor: pointer; padding: 0;">답글</button>
                                                                    <c:if test="${pageContext.request.userPrincipal.name == reply.writerId or pageContext.request.isUserInRole('ROLE_ADMIN')}">
                                                                        <button type="button" class="btn-comment-edit" data-comment-id="${reply.id}" style="background: none; border: none; color: #007bff; cursor: pointer; padding: 0;">수정</button>
                                                                        <button type="button" onclick="deleteComment(${reply.id})" style="background: none; border: none; color: #dc3545; cursor: pointer; padding: 0;">삭제</button>
                                                                    </c:if>
                                                                </div>
                                                            </sec:authorize>
                                                        </div>
                                                        <p style="margin: 5px 0;"><c:out value="${reply.content}"/></p>
                                                    </div>
                                                </c:forEach>
                                            </c:if>
                                        </div>

                                        <%-- 답글 작성 폼 --%>
                                        <div class="reply reply-form" id="reply-form-${comment.id}">
                                            <form onsubmit="submitReply(event, ${comment.id})">
                                                <textarea name="content" placeholder="답글을 입력하세요." required></textarea>
                                                <div style="text-align: right; margin-top: 5px;">
                                                    <button type="button" class="btn btn-sm btn-secondary" onclick="toggleReplyForm(${comment.id}, '${comment.writerId}')">취소</button>
                                                    <button type="submit" class="btn btn-sm btn-primary">등록</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p id="noCommentsMessage">아직 등록된 댓글이 없습니다.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                   
                </div>
                <%-- 원 댓글 작성 폼 --%>
                <sec:authorize access="isAuthenticated()">
                    <div class="comment-form" style="margin-top: 20px;">
                        <form id="commentForm">
                            <textarea name="content" placeholder="댓글을 입력하세요." required></textarea>
                            <button type="submit" class="btn btn-primary" style="margin-top: 5px;">등록</button>
                        </form>
                    </div>
                </sec:authorize>
            </c:if>

    <div class="button-container">
        <a href="${pageContext.request.contextPath}/admin/board/${category.code}" class="btn">목록</a>
        <%-- 수정 버튼: 목록 페이지의 수정 모달을 열도록 JavaScript 호출 --%>
        <button type="button" class="btn" onclick="goToEdit()">수정</button>
        <%-- 삭제 버튼: 목록 페이지의 삭제 함수를 호출 --%>
        <button type="button" class="btn btn-danger" onclick="deletePost()">삭제</button>
    </div>
</div>

<script>
    const C = '${pageContext.request.contextPath}';
    const categoryCode = '${category.code}';
    const postId = '${post.id}';

    function goToEdit() {
        // 수정 기능은 현재 목록 페이지의 모달을 통해 이루어지므로,
        // URL 파라미터를 통해 목록 페이지 로드 시 바로 모달을 열도록 할 수 있습니다.
        // 여기서는 간단하게 목록 페이지로 이동합니다.
        alert("게시글 수정은 목록 페이지에서 '수정' 버튼을 통해 가능합니다.");
        location.href = `${C}/admin/board/${categoryCode}`;
    }

    async function deletePost() {
        if (confirm('정말로 이 글을 삭제하시겠습니까?')) {
            try {
                const response = await fetch(`${C}/admin/board/api/${categoryCode}/${postId}/delete`, {
                    method: 'POST'
                });
                const result = await response.json();
                if (result.success) {
                    alert('성공적으로 삭제되었습니다.');
                    location.href = `${C}/admin/board/${categoryCode}`; // 삭제 후 목록으로 이동
                } else {
                    throw new Error(result.message || '삭제에 실패했습니다.');
                }
            } catch (error) {
                alert(error.message);
            }
        }
    }
    
    // 공통 댓글 제출 함수 (전역 스코프로 이동)
    async function submitComment(content, parentId) {
        if (!content.trim()) {
            alert('댓글 내용을 입력해주세요.');
            return;
        }
    
        const commentData = {
            postId: postId,
            parentId: parentId,
            content: content
        };
    
        // CSRF 토큰을 meta 태그에서 직접 읽어옴
        const token = document.querySelector("meta[name='_csrf']").getAttribute("content");
        const header = document.querySelector("meta[name='_csrf_header']").getAttribute("content");
    
        const requestHeaders = {
            'Content-Type': 'application/json'
        };

        // CSRF 헤더 이름이 존재할 경우에만 헤더에 추가
        if (header && token) {
            requestHeaders[header] = token;
        }

        try {
        	const response = await fetch(C + '/admin/api/comments', {
                method: 'POST',
                headers: requestHeaders,
                body: JSON.stringify(commentData)
            });
    
            if (response.ok) {
                location.reload(); // 성공 시 페이지 새로고침
            } else {
                const errorData = await response.json().catch(() => ({ message: response.statusText }));
                throw new Error(errorData.message || '댓글 등록에 실패했습니다.');
            }
        } catch (error) {
            alert('오류 발생: ' + error.message);
        }
    }

    $(document).ready(function() {
        // 원 댓글 작성
        $('#commentForm').on('submit', function(event) {
            event.preventDefault();
            const content = $('#commentForm textarea').val();
            submitComment(content, null); // parentId는 null
        });

        // 답글 작성
        window.submitReply = function(event, parentId) {
            event.preventDefault();
            const content = $(event.target).find('textarea').val();
            submitComment(content, parentId);
        };
        
     // 수정 버튼 클릭 이벤트 위임 (동적으로 생성된 댓글에도 적용)
        $('#commentList').on('click', '.btn-comment-edit', function() {
            const commentId = $(this).data('comment-id');
            // p 태그에서 직접 텍스트를 가져와서 작은따옴표 문제 원천 차단
            const currentContent = $('#comment-' + commentId).find('p').text();
            showEditForm(commentId, currentContent);
        });
     
     // 댓글 수정 폼을 보여주는 함수
        window.showEditForm = function(commentId, currentContent) {
            const commentDiv = $('#comment-' + commentId);
            const originalHtml = commentDiv.html(); // 취소를 위해 원본 HTML 저장

            const editFormHtml =
                '<div class="comment-edit-form">' +
                '    <textarea style="width: 100%; min-height: 60px;">' + currentContent + '</textarea>' +
                '    <div style="text-align: right; margin-top: 5px;">' +
                '        <button type="button" class="btn btn-sm btn-secondary" onclick="cancelEdit(' + commentId + ')">취소</button>' +
                '        <button type="button" class="btn btn-sm btn-primary" onclick="submitEdit(' + commentId + ')">저장</button>' +
                '    </div>' +
                '</div>';

            commentDiv.html(editFormHtml);
            
            // 원본 HTML을 data 속성에 저장
            commentDiv.data('original-html', originalHtml);
        };
        
        // 댓글 수정 취소
        window.cancelEdit = function(commentId) {
            const commentDiv = $('#comment-' + commentId);
            const originalHtml = commentDiv.data('original-html');
            commentDiv.html(originalHtml);
        };

        // 댓글 수정 제출
        window.submitEdit = function(commentId) {
            const commentDiv = $('#comment-' + commentId);
            const newContent = commentDiv.find('textarea').val();

            $.ajax({
                url: '${pageContext.request.contextPath}/admin/api/comments/' + commentId,
                type: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify({ content: newContent }),
                success: function(response) {
                    cancelEdit(commentId); // 폼을 원래대로 되돌림
                    $('#comment-' + commentId).find('p').text(response.content); // 내용만 업데이트
                    alert('댓글이 수정되었습니다.');
                },
                error: function(xhr) {
                    cancelEdit(commentId); // 수정 실패 시 원래대로 복원
                    alert('댓글 수정 실패: ' + (xhr.responseJSON ? xhr.responseJSON.message : xhr.statusText));
                }
            });
        };
        
        // 댓글 삭제 함수를 전역 스코프로 노출
        window.deleteComment = function(commentId) {
            if (!confirm('정말 이 댓글을 삭제하시겠습니까?')) {
                return;
            }

            $.ajax({
                url: '${pageContext.request.contextPath}/admin/api/comments/' + commentId,
                type: 'DELETE',
                success: function(response) {
                    if (response.success) {
                        alert('댓글이 삭제되었습니다.');
                        // 부모 wrapper를 찾아 삭제 (답글까지 함께)
                        const commentElement = $('#comment-' + commentId);
                        if (commentElement.parent().hasClass('comment-wrapper')) {
                            commentElement.parent().remove();
                        } else {
                            commentElement.remove();
                        }
                    }
                },
                error: function(xhr) {
                    alert('댓글 삭제 실패: ' + (xhr.responseJSON ? xhr.responseJSON.message : xhr.statusText));
                }
            });
        };
        
        
        // 답글 폼 토글
        window.toggleReplyForm = function(commentId, writerId) {
            const replyForm = $('#reply-form-' + commentId);
            const textarea = replyForm.find('textarea');

            // 폼을 보여주기 직전이고, 입력창이 비어있을 때만 아이디를 추가합니다.
            if (!replyForm.is(':visible') && textarea.val().trim() === '') {
                textarea.val('@' + writerId + ' ');
            }

            replyForm.toggle();
            if (replyForm.is(':visible')) textarea.focus(); // 폼이 보이면 포커스 이동
        };
        
        // 답글 작성
        window.submitReply = function(event, parentId) {
            event.preventDefault();
            const content = $(event.target).find('textarea').val();
            submitComment(content, parentId);
        };
   

    });
</script>

</body>
</html>