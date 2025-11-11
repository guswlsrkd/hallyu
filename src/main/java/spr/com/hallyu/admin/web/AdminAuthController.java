// spr/com/hallyu/admin/web/AdminAuthController.java
package spr.com.hallyu.admin.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import spr.com.hallyu.admin.service.AuthService;
import java.util.Collections;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminAuthController {
  @Resource private AuthService authService;

  @GetMapping("/login")
  public String loginForm() { return "admin/login"; }

  @PostMapping("/login")
  public String login(@RequestParam String username,
                      @RequestParam String password,
                      HttpServletRequest request, Model model) {

    Map<String, Object> user = authService.login(username, password);

    if (user != null) {
      // 1. 기존 방식: 단순 세션에 로그인 정보 저장
      HttpSession session = request.getSession();
      session.setAttribute("ADMIN_LOGIN", username);

      // 2. ★핵심★ Spring Security가 인식할 수 있는 인증 정보 생성 및 설정
      String role = (String) user.get("role");
      Authentication authentication = new UsernamePasswordAuthenticationToken(
          username, password, Collections.singletonList(new SimpleGrantedAuthority(role))
      );
      SecurityContext securityContext = SecurityContextHolder.getContext();
      securityContext.setAuthentication(authentication);

      // 3. 역할(Role)에 따라 리다이렉트 경로 분기
      if ("ROLE_ADMIN".equals(role)) {
        return "redirect:/admin/categories"; // 관리자는 관리자 카테고리 페이지로
      } else {
        return "redirect:/"; // 일반 사용자는 사용자 홈으로
      }
    }

    model.addAttribute("error", "로그인 실패");
    return "admin/login";
  }

  @PostMapping("/logout")
  public String logout(HttpSession session) {
    authService.logout(session);
    // Spring Security 컨텍스트도 비워줍니다.
    SecurityContextHolder.clearContext();
    return "redirect:/admin/login";
  }
}
