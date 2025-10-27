<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<h1>게시글 목록 (code = ${code})</h1>

<p><a href="<c:url value='/admin/board/post/form?code=${code}'/>">글쓰기</a></p>

<table border="1" cellpadding="6">
  <thead>
    <tr>
      <th>ID</th><th>제목</th><th>작성자</th><th>조회수</th><th>관리</th>
    </tr>
  </thead>
  <tbody>
    <c:forEach var="it" items="${items}">
      <tr>
        <td>${it.id}</td>
        <td><a href="<c:url value='/admin/board/post/form?code=${it.code}&id=${it.id}'/>">${it.title}</a></td>
        <td>${it.writer}</td>
        <td>${it.views}</td>
        <td>
          <form method="post" action="<c:url value='/admin/board/post/delete'/>"
                onsubmit="return confirm('삭제할까요?');">
            <input type="hidden" name="id" value="${it.id}">
            <input type="hidden" name="code" value="${code}">
            <button type="submit">삭제</button>
          </form>
        </td>
      </tr>
    </c:forEach>
    <c:if test="${empty items}">
      <tr><td colspan="5">게시글이 없습니다.</td></tr>
    </c:if>
  </tbody>
</table>
