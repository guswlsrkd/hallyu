package spr.com.hallyu.admin.security;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class OAuthFailureLogger implements AuthenticationFailureHandler {

  private final SimpleUrlAuthenticationFailureHandler delegate =
      new SimpleUrlAuthenticationFailureHandler("/admin/login?error");

  @Override
  public void onAuthenticationFailure(HttpServletRequest req, HttpServletResponse res,
                                      AuthenticationException ex)
      throws IOException, ServletException { // ← 여기!
	System.out.println("=================================================");
    System.err.println("[OAuthFailure] " + ex.getClass().getName() + " : " + ex.getMessage());
    ex.printStackTrace(); // 필요 없으면 주석 처리

    System.out.println("=================================================");
    delegate.onAuthenticationFailure(req, res, ex); // 이게 ServletException 던질 수 있음
  }
}
