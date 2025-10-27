// spr/com/hallyu/admin/web/AdminAuthInterceptor.java
package spr.com.hallyu.admin.web;

import javax.servlet.http.*;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class AdminAuthInterceptor extends HandlerInterceptorAdapter {
  @Override
  public boolean preHandle(HttpServletRequest req, HttpServletResponse res, Object handler) throws Exception {
    String uri = req.getRequestURI();
    if (uri.startsWith(req.getContextPath() + "/admin/login")) return true;
    Object login = req.getSession().getAttribute("ADMIN_LOGIN");
    if (login == null) {
      res.sendRedirect(req.getContextPath() + "/admin/login");
      return false;
    }
    return true;
  }
}
