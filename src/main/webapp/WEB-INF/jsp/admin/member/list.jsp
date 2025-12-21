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
  <meta charset="UTF-8"/>
  <title>회원 관리</title>

  <!-- (선택) Spring Security CSRF 메타 태그: 컨트롤러에서 _csrf 를 노출하고 있으면 사용 -->
  <c:if test="${not empty _csrf}">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <meta name="_csrf_param" content="${_csrf.parameterName}"/>
  </c:if>

  <jsp:useBean id="now" class="java.util.Date" />
  <fmt:formatDate value="${now}" pattern="yyyyMMddHHmmss" var="cssVer" />
  <link rel="stylesheet" href="<c:url value='/assets/admin/css/member.css'/>?v=${cssVer}">
</head>
<body>
<%@ include file="/WEB-INF/jsp/admin/_layout/header.jspf" %>
  <div class="page-header">
    <h2>회원 관리</h2>
    <a href="${pageContext.request.contextPath}/" class="btn" target="_blank" title="새 탭에서 열기">사용자 홈으로</a>
  </div>
  <p class="muted">시스템에 등록된 사용자 목록입니다.</p>

  <table>
    <thead>
      <tr>
        <th class="col-username">아이디 (username)</th>
        <th class="col-name">이름</th>
        <th class="col-role">권한</th>
        <th>이메일</th>
        <th class="col-date">가입일</th>
        <th class="col-menu">메뉴 권한</th>
        <th class="col-action">액션</th>
      </tr>
    </thead>
    <tbody>
    <c:forEach var="member" items="${members}">
      <tr>
        <td>
          <code>${member.USERNAME}</code>
        </td>
        <td>
          <c:out value="${member.NAME}"/>
        </td>
        <td>
          <c:choose>
            <c:when test="${member.ROLE == 'ROLE_ADMIN'}">
              <span class="badge admin">관리자</span>
            </c:when>
            <c:otherwise><span class="badge user">사용자</span></c:otherwise>
          </c:choose>
        </td>
        <td>
          <c:out value="${member.EMAIL}"/>
        </td>
        <td>
          <%-- DB에서 가져온 타임스탬프 형식에 맞게 pattern을 조정해야 할 수 있습니다. --%>
          <c:if test="${not empty member.CREATED_AT}">
            <fmt:parseDate value="${member.CREATED_AT}" pattern="yyyy-MM-dd HH:mm:ss.S" var="parsedDateTime"
                           type="both"/>
            <fmt:formatDate value="${parsedDateTime}" pattern="yyyy-MM-dd HH:mm" />
          </c:if>
        </td>
        <td>
          <button type="button" class="btn" onclick="openMenuAuthModal('${member.USERNAME}', '${member.NAME}')">관리</button>
        </td>
        <td>
          <div class="row-actions">
            <button type="button" class="btn" onclick="alert('수정 기능 구현 필요')">수정</button>
            <button type="button" class="btn" onclick="alert('삭제 기능 구현 필요')">삭제</button>
          </div>
        </td>
      </tr>
    </c:forEach>
    </tbody>
  </table>

  <!-- ====== 메뉴 권한 관리 모달 ====== -->
  <div id="menuAuthModal" class="modal-overlay">
    <div class="modal-dialog">
      <div class="modal-header">
        <h3 class="modal-title">메뉴 권한 관리</h3>
        <button type="button" onclick="closeMenuAuthModal()" class="modal-close-btn">×</button>
      </div>

      <div style="margin:6px 0 12px; color:#6b7280;">
        대상 회원: <strong id="auth-member-name"></strong>
        (<code class="mono" id="auth-member-username"></code>)
      </div>

      <form id="menuAuthForm" onsubmit="return submitMenuAuth(event)">
        <input type="hidden" id="auth-username" name="username" />

        <div id="menu-tree-container" class="menu-tree-container">
          <!-- 메뉴 트리(체크박스)가 여기에 동적으로 생성됩니다. -->
          <p class="muted">메뉴 목록을 불러오는 중...</p>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn" onclick="closeMenuAuthModal()">취소</button>
          <button type="submit" class="btn btn-primary">권한 저장</button>
        </div>
      </form>

      <div id="menuAuthAlert" class="alert-msg"></div>
    </div>
  </div>
  <!-- ====== /메뉴 권한 관리 모달 ====== -->

<script>
  // 컨텍스트 경로
  var C = '${pageContext.request.contextPath}';

  // 모달 열기
  async function openMenuAuthModal(username, name) {
    // 폼 초기화
    document.getElementById('menuAuthAlert').style.display = 'none';
    document.getElementById('menu-tree-container').innerHTML = '<p class="muted">메뉴 목록을 불러오는 중...</p>';

    // 대상 회원 정보 표시
    document.getElementById('auth-username').value = username;
    document.getElementById('auth-member-username').textContent = username;
    document.getElementById('auth-member-name').textContent = name;

    // 모달 표시
    document.getElementById('menuAuthModal').style.display = 'block';

    try {
      // API를 병렬로 호출하여 메뉴 트리와 사용자 권한을 가져옴
      const [menuRes, permRes] = await Promise.all([
        fetch(C + '/admin/members/api/menu-tree'),
        fetch(C + '/admin/members/api/' + username + '/permissions')
      ]);

      if (!menuRes.ok || !permRes.ok) {
        throw new Error('데이터를 불러오는 데 실패했습니다.');
      }

      const menuTree = await menuRes.json();
      const userPermissions = await permRes.json();

      // 메뉴 트리를 기반으로 체크박스 HTML 생성
      const menuContainer = document.getElementById('menu-tree-container');
      menuContainer.innerHTML = buildMenuHtml(menuTree, userPermissions);

    } catch (error) {
      console.error('Error fetching menu permissions:', error);
      document.getElementById('menu-tree-container').innerHTML = '<p style="color: #b91c1c;">메뉴 목록을 불러오는 중 오류가 발생했습니다.</p>';
    }
  }

  // 메뉴 트리 HTML을 재귀적으로 생성하는 함수
  function buildMenuHtml(nodes, userPermissions) {
    let html = '';
    if (!nodes || nodes.length === 0) {
      return '<p class="muted">표시할 메뉴가 없습니다.</p>';
    }
    for (const node of nodes) {
      const isChecked = userPermissions.includes(node.code);
      const depth = node.depth || 0;
      html += '<div class="menu-item" style="margin-left: ' + (depth * 20) + 'px;"><label><input type="checkbox" name="menu-permission" value="' + node.code + '" ' + (isChecked ? 'checked' : '') + '> ' + node.name + ' (<code class="mono" style="font-size:11px;">' + node.code + '</code>)</label></div>';
    }
    return html;
  }

  // 모달 닫기
  function closeMenuAuthModal() {
    document.getElementById('menuAuthModal').style.display = 'none';
  }

  // 권한 저장 (폼 제출)
  async function submitMenuAuth(event) {
    event.preventDefault(); // 폼 기본 제출 방지

    const username = document.getElementById('auth-username').value;
    const checkedBoxes = document.querySelectorAll('input[name="menu-permission"]:checked');
    const selectedCodes = Array.from(checkedBoxes).map(cb => cb.value);

    const alertDiv = document.getElementById('menuAuthAlert');
    alertDiv.style.display = 'none';

    try {
      const response = await fetch(C + '/admin/members/api/' + username + '/permissions', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ categoryCodes: selectedCodes })
      });

      if (!response.ok) throw new Error('저장에 실패했습니다.');

      alert('권한이 성공적으로 저장되었습니다.');
      closeMenuAuthModal();
    } catch (error) {
      alertDiv.textContent = '오류가 발생했습니다: ' + error.message;
      alertDiv.style.display = 'block';
    }
  }
</script>
</body>
</html>
