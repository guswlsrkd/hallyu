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
	<link rel="stylesheet" href="<c:url value='/assets/common/css/board.css'/>">
    
	<script type="text/javascript" src="<c:url value='/assets/common/js/jquery-3.7.1.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/assets/common/js/common.js'/>"></script>

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
                <c:out value="${post.content}" escapeXml="false" />
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
             <!-- ================= 댓글 영역 시작 ================= -->
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
                        <form id="commentForm" onsubmit="submitRootComment(event)">
                            <textarea name="content" placeholder="댓글을 입력하세요." required></textarea>
                            <button type="submit" class="btn btn-primary" style="margin-top: 5px;">등록</button>
                        </form>
                    </div>
                </sec:authorize>
            </c:if>
            <c:if test="${category['use_comments'] != 'Y'}">
                <div class="comments-area">
                    <p>이 게시판은 댓글 작성이 허용되지 않습니다.</p>
                </div>
            </c:if>
            <!-- ================= 댓글 영역 끝 ================= -->

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
//deleteForm이 존재할 때만 이벤트 리스너를 추가하여 JavaScript 오류를 방지합니다.
const deleteForm = document.getElementById('deleteForm');
if (deleteForm) {
    deleteForm.addEventListener('submit', function(event) {
        // 폼의 기본 제출 동작을 막습니다.
        event.preventDefault();
        // 사용자에게 삭제 여부를 확인합니다.
        if (confirm('정말 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
            // '확인'을 누르면 폼을 제출합니다.
            this.submit();
        }
    });
}
    
    // jQuery: 문서가 준비되면 스크립트 실행
    $(document).ready(function() {

        // CSRF 토큰 설정 (오류 방지를 위해 null 체크 추가)
        const csrfTokenEl = document.querySelector('meta[name="_csrf"]'); // CSRF 토큰 메타 태그
        const csrfHeaderEl = document.querySelector('meta[name="_csrf_header"]'); // CSRF 헤더 이름 메타 태그
        const csrfToken = csrfTokenEl ? csrfTokenEl.getAttribute('content') : null;
        const csrfHeader = csrfHeaderEl ? csrfHeaderEl.getAttribute('content') : null;

        // 공통 댓글 제출 함수
        function submitComment(content, parentId) {
            if (!content.trim()) {
                alert('댓글 내용을 입력해주세요.');
                return;
            }

            const commentData = {
                postId: '${post.id}',
                parentId: parentId, // 부모 ID 추가 (원 댓글은 null)
                content: content
            };

            $.ajax({
                url: '${pageContext.request.contextPath}/api/comments', // 공통 URL 사용
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(commentData),
                beforeSend: function(xhr) {
                     if (csrfHeader && csrfToken) {
                        xhr.setRequestHeader(csrfHeader, csrfToken);
                    }
                },
                success: function(response) {
                    const isReply = response.parentId != null;
                    const newCommentHtml = 
                        '<div class="comment" id="comment-' + response.id + '">' +
                        '    <div class="comment-meta">' +
                        '        <strong>' + response.writerId + '</strong> | ' + new Date(response.createdAt).toLocaleString('ko-KR') + 
                        '        <div style="float: right; font-size: 12px; display: inline-flex; gap: 8px;">' +
                        '            <button type="button" onclick="toggleReplyForm(' + (isReply ? response.parentId : response.id) + ', \'' + response.writerId + '\')" style="background: none; border: none; color: #6c757d; cursor: pointer; padding: 0;">답글</button>' +
                        ( (response.writerId === '${pageContext.request.userPrincipal.name}' || '${pageContext.request.isUserInRole("ROLE_ADMIN")}' === 'true' ) ?
                            '            <button type="button" class="btn-comment-edit" data-comment-id="' + response.id + '" style="background: none; border: none; color: #007bff; cursor: pointer; padding: 0;">수정</button>' +
                            '            <button type="button" onclick="deleteComment(' + response.id + ')" style="background: none; border: none; color: #dc3545; cursor: pointer; padding: 0;">삭제</button>'
                            : ''
                        ) +
                        '        </div>' +
                        '    </div>' +
                        '    <p style="margin: 5px 0;">' + response.content + '</p>' +
                        '</div>';
                    if (isReply) {
                        $('#reply-list-' + response.parentId).append(newCommentHtml);
                        const replyForm = $('#reply-form-' + response.parentId);
                        replyForm.hide();
                        replyForm.find('textarea').val('');
                    } else {
                        const newCommentWrapper = 
                            '<div class="comment-wrapper" id="comment-wrapper-' + response.id + '">' +
                                newCommentHtml +
                            '    <div class="reply" id="reply-list-' + response.id + '"></div>' +
                            '    <div class="reply reply-form" id="reply-form-' + response.id + '">' +
                            '        <form onsubmit="submitReply(event, ' + response.id + ')">' +
                            '            <textarea name="content" placeholder="답글을 입력하세요." required></textarea>' +
                            '            <div style="text-align: right; margin-top: 5px;">' + 
                            '                <button type="button" class="btn btn-sm btn-secondary" onclick="toggleReplyForm(' + response.id + ')">취소</button>' +
                            '                <button type="submit" class="btn btn-sm btn-primary">등록</button>' +
                            '            </div>' +
                            '        </form>' +
                            '    </div>' +
                            '</div>';
                        $('#noCommentsMessage').remove();
                        $('#commentList').append(newCommentWrapper);
                        $('#commentForm textarea').val('');
                    }
                },
                error: function(xhr) {
                    alert('댓글 등록 실패: ' + (xhr.responseJSON ? xhr.responseJSON.message : xhr.statusText));
                }
            });
        }

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
                url: '${pageContext.request.contextPath}/api/comments/' + commentId,
                type: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify({ content: newContent }),
                beforeSend: function(xhr) {
                    if (csrfHeader && csrfToken) {
                        xhr.setRequestHeader(csrfHeader, csrfToken);
                    }
                },
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

        // 원 댓글 작성
        window.submitRootComment = function(event) {
            event.preventDefault();
            const content = $('#commentForm textarea').val();
            submitComment(content, null); // parentId는 null
        };

        // 답글 작성
        window.submitReply = function(event, parentId) {
            event.preventDefault();
            const content = $(event.target).find('textarea').val();
            submitComment(content, parentId);
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

        // 댓글 삭제 함수를 전역 스코프로 노출
        window.deleteComment = function(commentId) {
            if (!confirm('정말 이 댓글을 삭제하시겠습니까?')) {
                return;
            }

            $.ajax({
                url: '${pageContext.request.contextPath}/api/comments/' + commentId,
                type: 'DELETE',
                beforeSend: function(xhr) {
                    if (csrfHeader && csrfToken) {
                        xhr.setRequestHeader(csrfHeader, csrfToken);
                    }
                },
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
    });
</script>
</html>