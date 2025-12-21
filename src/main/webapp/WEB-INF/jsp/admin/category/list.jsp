<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
  // 컨텍스트 경로
  String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>카테고리 관리</title>

  <!-- (선택) Spring Security CSRF 메타 태그: 컨트롤러에서 _csrf 를 노출하고 있으면 사용 -->
  <c:if test="${not empty _csrf}">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <meta name="_csrf_param" content="${_csrf.parameterName}"/>
  </c:if>

  <jsp:useBean id="now" class="java.util.Date" />
  <fmt:formatDate value="${now}" pattern="yyyyMMddHHmmss" var="cssVer" />
  <link rel="stylesheet" href="<c:url value='/assets/admin/css/category.css'/>?v=${cssVer}">
</head>
<body>
<%@ include file="/WEB-INF/jsp/admin/_layout/header.jspf" %>
  <div class="page-header">
    <h2>카테고리 관리</h2>
    <a href="${pageContext.request.contextPath}/" class="btn" target="_blank" title="새 탭에서 열기">사용자 홈으로</a>
  </div>
  <p class="muted">표시 토글, 위/아래 정렬, 수정, 하위 등록 등의 기능을 사용할 수 있습니다.</p>

  <table>
    <thead>
      <tr>
        <th style="width:18%">코드</th>
        <th>이름</th>
        <th style="width:16%">부모</th>
        <th style="width:10%">깊이</th>
        <th style="width:10%">정렬</th>
        <th style="width:10%">표시</th>
        <th style="width:26%">액션</th>
      </tr>
    </thead>
    <tbody>
    <c:forEach var="it" items="${categories}">
      <tr data-code="${it.code}" data-parent="${it.parent_code}">
  <td style="padding-left: ${(empty it.depth ? 0 : it.depth) * 20}px;">
    <c:if test="${not empty it.depth and it.depth > 0}">
      <span style="color: #888; font-size: 1.1em; vertical-align: middle;">ㄴ&nbsp;</span>
    </c:if>
    <code>${it.code}</code></td>
  <td>
    <c:out value="${it.name}"/>
    <div class="muted"><c:out value="${it.path}"/></div>
  </td>
  <td><c:out value="${empty it.parent_code ? 'ROOT' : it.parent_code}"/></td>
  <td>${empty it.depth ? 0 : it.depth}</td>
  <td>${it.sort_order}</td>
        <td>
          <c:choose>
            <c:when test="${it.visible == 'Y'}"><span class="badge on">보임</span></c:when>
            <c:otherwise><span class="badge off">숨김</span></c:otherwise>
          </c:choose>
        </td>
        <td>
          <div class="row-actions">
            <!-- 정렬: 위/아래 (POST) -->
            <form method="post" action="${pageContext.request.contextPath}/admin/categories/${it.code}/moveUp" style="display:inline">
              <input type="hidden" name="parentCode" value="${it.parent_code}" />
              <button type="submit" class="btn btn-up" title="위로">▲</button>
            </form>

            <form method="post" action="${pageContext.request.contextPath}/admin/categories/${it.code}/moveDown" style="display:inline">
              <input type="hidden" name="parentCode" value="${it.parent_code}" />
              <button type="submit" class="btn btn-down" title="아래로">▼</button>
            </form>

            <!-- 표시 토글 (POST) -->
            <form method="post" action="${pageContext.request.contextPath}/admin/categories/${it.code}/toggleVisible" style="display:inline">
              <input type="hidden" name="visible" value="<c:out value='${it.visible == "Y" ? "N" : "Y"}'/>" />
              <button type="submit" class="btn">
                <c:out value='${it.visible == "Y" ? "숨기기" : "보이기"}'/>
              </button>
            </form>
            
            <!-- 수정 (GET) -->
			<button type="button"
        		    class="btn btn-edit"
        			data-code="${it.code}"
        			onclick="openEditModal('${it.code}')">
  					수정
			</button>
			
			<!-- 하위등록: 팝업 오픈 -->
			<button type="button"
        			class="btn btn-child"
        			onclick="openChildModal('${it.code}', '${fn:escapeXml(it.name)}')">
  					＋하위
			</button>

            <!-- 하위 메뉴에만 삭제 버튼 표시 -->
            <c:if test="${not empty it.depth and it.depth > 0}">
              <button type="button" class="btn" onclick="deleteCategory('${it.code}')">삭제</button>
            </c:if>
          </div>
        </td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
  
  <!-- ====== 수정 모달 ====== -->
<div id="editModal" class="modal-overlay">
  <div class="modal-dialog">
    <div class="modal-header">
      <h3 class="modal-title">카테고리 수정</h3>
      <button type="button" onclick="closeEditModal()" class="modal-close-btn">×</button>
    </div>

    <form id="editForm" onsubmit="return submitEdit(event)">
      <input type="hidden" name="code" id="edit-code" />

      <div class="form-row">
        <label>코드</label>
        <input type="text" id="edit-code-view" class="mono" readonly />
      </div>

      <div class="form-row">
        <label>이름</label>
        <input type="text" name="name" id="edit-name" required />
      </div>

      <div class="form-row">
        <label>경로(Path)</label>
        <input type="text" name="path" id="edit-path" placeholder="/k-food/intro" />
      </div>
      
      <div class="form-row mb-14">
        <label>댓글 사용 여부</label>
        <label><input type="radio" name="useComments" value="Y" checked /> 사용</label>
        <label style="margin-left:8px;"><input type="radio" name="useComments" value="N" /> 미사용</label>
      </div>

      <div class="form-row">
        <label>사용 여부</label>
        <label><input type="radio" name="useYn" value="Y" checked /> 사용</label>
        <label style="margin-left:8px;"><input type="radio" name="useYn" value="N" /> 미사용</label>
      </div>

      <div class="form-row mb-14">
        <label>표시 여부</label>
        <label><input type="radio" name="visible" value="Y" checked /> 표시</label>
        <label style="margin-left:8px;"><input type="radio" name="visible" value="N" /> 비표시</label>
      </div>

      <div class="form-row mb-14">
        <label for="edit-write-auth">글쓰기 권한</label>
        <select name="writeAuth" id="edit-write-auth" style="padding: 4px;">
          <option value="ROLE_USER">사용자 이상</option>
          <option value="ROLE_ADMIN">관리자만</option>
        </select>
      </div>

      <div class="modal-footer">
        <button type="button" class="btn" onclick="closeEditModal()">취소</button>
        <button type="submit" class="btn btn-primary">저장</button>
      </div>
    </form>

    <div id="editAlert" class="alert-msg"></div>
  </div>
</div>
<!-- ====== /수정 모달 ====== -->

<!-- ====== 하위등록 모달 ====== -->
<div id="childModal" class="modal-overlay">
  <div class="modal-dialog">
    <div class="modal-header">
      <h3 class="modal-title">하위 카테고리 등록</h3>
      <button type="button" onclick="closeChildModal()" class="modal-close-btn">×</button>
    </div>

    <form id="childForm" onsubmit="return submitChild(event)">
      <input type="hidden" id="child-parent-code" name="parentCode" />

      <div style="margin:6px 0 12px; color:#6b7280;">
        부모: <strong id="child-parent-name"></strong>
        (<code class="mono" id="child-parent-code-view"></code>)
      </div>

      <div class="form-row">
        <label>코드</label>
        <input type="text" name="code" id="child-code" placeholder="예: intro" required />
      </div>

      <div class="form-row">
        <label>이름</label>
        <input type="text" name="name" id="child-name" required />
      </div>

      <div class="form-row">
        <label>경로(Path)</label>
        <input type="text" name="path" id="child-path" placeholder="/board/intro" />
      </div>
      
       <!-- 댓글 사용 여부 체크박스 추가 -->
      <div class="form-row mb-14">
        <label>댓글 사용 여부</label>
        <label><input type="radio" name="useComments" value="Y" checked /> 사용</label>
        <label style="margin-left:8px;"><input type="radio" name="useComments" value="N" /> 미사용</label>
      </div>

      <div class="form-row">
        <label>사용 여부</label>
        <label><input type="radio" name="useYn" value="Y" checked /> 사용</label>
        <label style="margin-left:8px;"><input type="radio" name="useYn" value="N" /> 미사용</label>
      </div>

      <div class="form-row mb-14">
        <label>표시 여부</label>
        <label><input type="radio" name="visible" value="Y" checked /> 표시</label>
        <label style="margin-left:8px;"><input type="radio" name="visible" value="N" /> 비표시</label>
      </div>

      <div class="form-row mb-14">
        <label for="child-write-auth">글쓰기 권한</label>
        <select name="writeAuth" id="child-write-auth" style="padding: 4px;">
          <option value="ROLE_USER">사용자 이상</option>
          <option value="ROLE_ADMIN">관리자만</option>
        </select>
      </div>

      <div class="modal-footer">
        <button type="button" class="btn" onclick="closeChildModal()">취소</button>
        <button type="submit" class="btn btn-primary">등록</button>
      </div>
    </form>

    <div id="childAlert" class="alert-msg"></div>
  </div>
</div>
<!-- ====== /하위등록 모달 ====== -->
  

<script>
(function() {
  // CSRF(있을 때만) 자동 부착: form submit 시 파라미터로 추가
  var token = document.querySelector('meta[name="_csrf"]');
  var param = document.querySelector('meta[name="_csrf_param"]');
  if (token && param) {
    var t = token.getAttribute('content');
    var p = param.getAttribute('content');
    Array.prototype.forEach.call(document.querySelectorAll('form[method="post"]'), function(f) {
      if (!f.querySelector('input[name="'+p+'"]')) {
        var hidden = document.createElement('input');
        hidden.type = 'hidden';
        hidden.name = p;
        hidden.value = t;
        f.appendChild(hidden);
      }
    });
  }

  // 삭제 기능 (AJAX DELETE 요청)
  window.deleteCategory = function(code) {
    if (!confirm('정말 삭제하시겠습니까? 이 카테고리에 속한 모든 하위 카테고리와 게시글도 삭제됩니다.')) return;
    
    var headers = {};
    var c = csrf();
    if (c) headers[c.header] = c.token;

    fetch(C + '/admin/categories/' + encodeURIComponent(code), {
      method: 'DELETE',
      headers: headers
    })
    .then(function(res){ if(!res.ok) { return res.json().then(err => { throw new Error(err.message || '삭제 실패'); }); } location.reload(); })
    .catch(function(e){ alert('삭제 중 오류 발생: ' + e.message); });
  };
})();
</script>

<script>
  // 컨텍스트 경로
  var C = '${pageContext.request.contextPath}';

  // (선택) Spring Security CSRF 메타태그 사용 시 자동 수집
  function csrf() {
    var h = document.querySelector('meta[name="_csrf_header"]');
    var t = document.querySelector('meta[name="_csrf"]');
    return (h && t) ? { header: h.getAttribute('content'), token: t.getAttribute('content') } : null;
  }

  // 모달 열기
  async function openEditModal(code) {
    // 초기화
    document.getElementById('editAlert').style.display = 'none';
    document.getElementById('editForm').reset();

    // 단건 조회
    const res = await fetch(C + '/admin/categories/' + encodeURIComponent(code), {
      method: 'GET',
      headers: { 'Accept': 'application/json' }
    });
    if (!res.ok) {
      alert('카테고리 정보를 불러오지 못했습니다. (' + res.status + ')');
      return;
    }
    const data = await res.json();

    // 폼 채우기 (필드명은 서비스 반환 키에 맞춰 조정)
    document.getElementById('edit-code').value = data.code || code;
    document.getElementById('edit-code-view').value = data.code || code;
    document.getElementById('edit-name').value = data.name || '';
    document.getElementById('edit-path').value = data.path || '';

    // useYn 라디오
    var useYn = (data.use_yn || 'Y');
    document.querySelector('#editForm input[name="useYn"][value="' + (useYn === 'N' ? 'N' : 'Y') + '"]').checked = true;

    // visible 라디오 (data.visible 이 Boolean일 수도, 'Y'/'N'일 수도 있음)
    var visible = data.visible;
    var visibleYn = (visible === true || visible === 'Y') ? 'Y' : 'N';
    document.querySelector('#editForm input[name="visible"][value="' + visibleYn + '"]').checked = true;

    // 글쓰기 권한 select 채우기
    document.getElementById('edit-write-auth').value = data.write_auth || 'ROLE_USER';
    
    // 댓글 사용 여부 라디오 버튼 채우기
    var useCommentsYn = (data.use_comments === 'N' ? 'N' : 'Y');
    document.querySelector('#editForm input[name="useComments"][value="' + useCommentsYn + '"]').checked = true;


    // 모달 표시
    document.getElementById('editModal').style.display = 'block';
  }

  function closeEditModal() {
    document.getElementById('editModal').style.display = 'none';
  }

  // 저장(ajax PUT)
  async function submitEdit(ev) {
    ev.preventDefault();
    const form = document.getElementById('editForm');
    const code = document.getElementById('edit-code').value;

    // 폼 데이터 → x-www-form-urlencoded 로 전송 (컨트롤러 @RequestParam과 매칭)
    const fd = new URLSearchParams(new FormData(form));

    const headers = { 'Accept': 'application/json', 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' };
    const c = csrf();
    if (c) headers[c.header] = c.token;

    try {
      const res = await fetch(C + '/admin/categories/' + encodeURIComponent(code), {
        method: 'PUT',
        headers,
        body: fd.toString()
      });
      if (!res.ok) {
        const msg = '저장 실패 (' + res.status + ')';
        showEditError(msg);
        return false;
      }
      // 서버의 ok() JSON 기준으로 성공 처리
      // ex) {result:"ok"}라면:
      // const json = await res.json();

      closeEditModal();
      // 목록 새로고침(가장 간단)
      location.href = C + '/admin/categories?updated=' + encodeURIComponent(code);
    } catch (e) {
      showEditError('네트워크 오류: ' + e.message);
    }
    return false;
  }

  function showEditError(msg) {
    var el = document.getElementById('editAlert');
    el.textContent = msg;
    el.style.display = 'block';
  }
</script>

<script>
  // 모달 열기
  function openChildModal(parentCode, parentName) {
    document.getElementById('childAlert').style.display = 'none';
    document.getElementById('childForm').reset();

    document.getElementById('child-parent-code').value = parentCode;
    document.getElementById('child-parent-code-view').textContent = parentCode || '';
    document.getElementById('child-parent-name').textContent = parentName || '';

    document.getElementById('childModal').style.display = 'block';
    document.getElementById('child-code').focus();
  }

  function closeChildModal() {
    document.getElementById('childModal').style.display = 'none';
  }

  // 등록 (POST x-www-form-urlencoded → @RequestParam 매핑)
  async function submitChild(ev) {
    ev.preventDefault();

    const parentCode = document.getElementById('child-parent-code').value;
    const form = document.getElementById('childForm');
    const fd = new URLSearchParams(new FormData(form));

    const headers = { 'Accept':'application/json', 'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8' };
    const c = csrf(); if (c) headers[c.header] = c.token;

    try {
      const res = await fetch(C + '/admin/categories/' + encodeURIComponent(parentCode) + '/children', {
        method: 'POST',
        headers,
        body: fd.toString()
      });
      if (!res.ok) {
        showChildError('등록 실패 (' + res.status + ')');
        return false;
      }
      closeChildModal();
      // 가장 간단: 목록 새로고침
      location.href = C + '/admin/categories?created=' + encodeURIComponent(document.getElementById('child-code').value);
    } catch (e) {
      showChildError('네트워크 오류: ' + e.message);
    }
    return false;
  }

  function showChildError(msg) {
    var el = document.getElementById('childAlert');
    el.textContent = msg;
    el.style.display = 'block';
  }
</script>



</body>
</html>
