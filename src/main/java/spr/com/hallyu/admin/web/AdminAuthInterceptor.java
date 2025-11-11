// spr/com/hallyu/admin/web/AdminAuthInterceptor.java
package spr.com.hallyu.admin.web;

import javax.servlet.http.*;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class AdminAuthInterceptor extends HandlerInterceptorAdapter {
  @Override
  public boolean preHandle(HttpServletRequest req, HttpServletResponse res, Object handler) throws Exception {
    HttpSession session = req.getSession();
    String uri = req.getRequestURI();
    String contextPath = req.getContextPath();
    Object login = session.getAttribute("ADMIN_LOGIN");

    // 1. 최상위 /admin 또는 /admin/ 경로를 가장 먼저 처리
    if (uri.equals(contextPath + "/admin") || uri.equals(contextPath + "/admin/")) {
      if (login != null) {
        // 관리자 세션이 있으면 /admin/categories 로 리다이렉트
        res.sendRedirect(contextPath + "/admin/categories");
      } else {
        // 관리자 세션이 없으면 로그인 페이지로 리다이렉트
        res.sendRedirect(contextPath + "/admin/login");
      }
      return false; // 컨트롤러로 더 이상 진행하지 않음
    }

    // 2. 로그인 페이지 자체는 항상 통과
    if (uri.startsWith(contextPath + "/admin/login")) return true;

    // 3. 그 외 모든 /admin/** 경로는 로그인 세션이 없으면 로그인 페이지로 리다이렉트
    if (login == null) { 
      res.sendRedirect(contextPath + "/admin/login");
      return false;
    }
    return true;
  }
}
