<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<h1>카테고리 관리(계층형)</h1>

<style>
  table.cat { border-collapse: collapse; width: 100%; }
  table.cat th, table.cat td { border:1px solid #ddd; padding:8px; }
  .indent { display:inline-block; }
  .actions form { display:inline; margin-right:4px; }
  .muted { color:#999; }
</style>

<table class="cat">
  <thead>
    <tr>
      <th style="width:220px">코드</th>
      <th>이름</th>
      <th>경로</th>
      <th style="width:100px">부모</th>
      <th style="width:70px">정렬</th>
      <th style="width:70px">표시</th>
      <th style="width:220px">작업</th>
    </tr>
  </thead>
  <tbody>
    <c:forEach var="it" items="${items}">
      <tr>
        <td>
          <span class="indent" style="padding-left:${it.depth * 20}px"></span>
          ${it.code}
        </td>
        <td>${it.name}</td>
        <td class="muted">${it.path}</td>
        <td>${it.parentCode}</td>
        <td>${it.sortOrder}</td>
        <td><c:out value="${it.visible ? 'Y' : 'N'}"/></td>
        <td class="actions">
          <!-- 위/아래 이동 -->
          <form method="post" action="<c:url value='/admin/category/move-up'/>">
            <input type="hidden" name="code" value="${it.code}"/><button>▲</button>
          </form>
          <form method="post" action="<c:url value='/admin/category/move-down'/>">
            <input type="hidden" name="code" value="${it.code}"/><button>▼</button>
          </form>
          <!-- 하위 추가(아래 폼에 값 채워서 이동) -->
          <form method="get" action="<c:url value='/admin/category/list'/>">
            <input type="hidden" name="edit" value="${it.code}"/>
            <button>하위추가</button>
          </form>
          <!-- 수정 폼으로 값 채움 -->
          <form method="get" action="<c:url value='/admin/category/list'/>">
            <input type="hidden" name="edit" value="${it.code}"/>
            <button>편집</button>
          </form>
          <!-- 삭제 -->
          <form method="post" action="<c:url value='/admin/category/delete'/>"
                onsubmit="return confirm('삭제할까요? (자식 있으면 실패)');">
            <input type="hidden" name="code" value="${it.code}"/>
            <button>삭제</button>
          </form>
        </td>
      </tr>
    </c:forEach>
  </tbody>
</table>

<hr/>

<h2>추가/수정</h2>
<%
  // editItem 이 있으면 편집 모드, 없으면 신규(상위추가 또는 루트추가)
%>
<c:set var="editing" value="${not empty editItem}"/>

<form method="post" action="<c:url value='${editing ? "/admin/category/update" : "/admin/category/create"}'/>">
  <table>
    <tr>
      <td>code</td>
      <td>
        <input name="code" value="${editing ? editItem.code : ''}" ${editing ? 'readonly' : ''} required/>
      </td>
      <td>name</td>
      <td><input name="name" value="${editing ? editItem.name : ''}" required/></td>
    </tr>
    <tr>
      <td>path</td>
      <td><input name="path" value="${editing ? editItem.path : ''}" required style="width:300px"/></td>
      <td>parent_code</td>
      <td>
        <input name="parentCode"
               value="${editing ? editItem.parentCode : (param.edit != null ? param.edit : '')}"/>
        <span class="muted">비우면 최상위</span>
      </td>
    </tr>
    <tr>
      <td>depth</td>
      <td><input name="depth" value="${editing ? editItem.depth : (param.edit != null ? 1 : 0)}" style="width:60px"/></td>
      <td>visible</td>
      <td>
        <label><input type="checkbox" name="visible" value="true"
          <c:if test="${editing ? editItem.visible : true}">checked</c:if>/> 노출</label>
        &nbsp; use_yn
        <input name="useYn" value="${editing ? editItem.useYn : 'Y'}" style="width:40px"/>
      </td>
    </tr>
  </table>
  <div style="margin-top:8px">
    <button type="submit">${editing ? '수정' : '저장'}</button>
    <a href="<c:url value='/admin/category/list'/>">초기화</a>
  </div>
</form>

<!-- 루트 카테고리 바로 추가(선택) -->
<h3>루트 카테고리 추가</h3>
<form method="post" action="<c:url value='/admin/category/create'/>">
  <input name="code" placeholder="code" required/>
  <input name="name" placeholder="name" required/>
  <input name="path" placeholder="/path" required/>
  <input type="hidden" name="parentCode" value=""/>
  <input type="hidden" name="depth" value="0"/>
  <label><input type="checkbox" name="visible" value="true" checked/> 노출</label>
  <input name="useYn" value="Y" style="width:40px"/>
  <button>추가</button>
</form>
