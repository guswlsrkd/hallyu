package spr.com.hallyu.admin.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import spr.com.hallyu.admin.service.AuthService;

@Controller
@RequestMapping("/admin")
public class AdminAuthController {
  @Resource private AuthService authService;

  @GetMapping("/login")
  public String loginForm() { return "admin/login"; }

  @PostMapping("/login")
  public String login(@RequestParam String username,
                      @RequestParam String password,
                      HttpSession session, Model model) {
    if (authService.login(username, password)) {
      session.setAttribute("ADMIN_LOGIN", username);
      return "redirect:/admin/board/posts?code=notice";
    }
    model.addAttribute("error", "로그인 실패");
    return "admin/login";
  }

  @PostMapping("/logout")
  public String logout(HttpSession session) {
    authService.logout(session);
    return "redirect:/admin/login";
  }
}
