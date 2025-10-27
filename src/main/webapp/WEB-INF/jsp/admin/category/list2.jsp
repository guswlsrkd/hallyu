<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<h1>카테고리 관리</h1>

<table border="1" cellpadding="6">
  <tr><th>code</th><th>name</th><th>path</th><th>parent</th><th>sort</th><th>use</th><th>visible</th><th>삭제</th></tr>
  <c:forEach var="it" items="${items}">
    <tr>
      <td>${it.code}</td><td>${it.name}</td><td>${it.path}111111</td>
      <td>${it.parentCode}</td><td>${it.sortOrder}</td><td>${it.useYn}</td><td>${it.visible}</td>
      <td>
        <form method="post" action="<c:url value='/admin/category/delete'/>" onsubmit="return confirm('삭제?');">
          <input type="hidden" name="code" value="${it.code}">
          <button>삭제</button>
        </form>
      </td>
    </tr>
  </c:forEach>
</table>

<h2>추가/수정</h2>
<form method="post" action="<c:url value='/admin/category/save'/>">
  code <input name="code" required>
  name <input name="name" required>
  path <input name="path" required>
  parent_code <input name="parentCode">
  depth <input name="depth" value="0">
  sort_order <input name="sortOrder" value="0">
  use_yn <input name="useYn" value="Y">
  visible <input type="checkbox" name="visible" value="true" checked>
  <button>저장</button>
</form>
