package spr.com.hallyu.admin.security;

import java.io.IOException;
import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import spr.com.hallyu.admin.mapper.AdminUserMapper;

public class AdminCheckSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {

    @Resource
    private AdminUserMapper adminUserMapper;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {
        String emailAsUsername = authentication.getName(); // 구글 이메일을 username으로 사용

        boolean allowed = adminUserMapper.existsByUsername(emailAsUsername) > 0;
        if (!allowed) {
            SecurityContextHolder.clearContext();
            getRedirectStrategy().sendRedirect(request, response, "/admin/login?denied");
            return;
        }

        super.onAuthenticationSuccess(request, response, authentication);
    }
}
