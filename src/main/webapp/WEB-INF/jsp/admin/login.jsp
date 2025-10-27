<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<h1>관리자 로그인</h1>
<c:if test="${not empty error}"><p style="color:red">${error}</p></c:if>
<form method="post" action="<c:url value='/admin/login'/>">
  <input name="username" placeholder="ID">
  <input name="password" type="password" placeholder="PW">
  <button>로그인</button>
</form>
