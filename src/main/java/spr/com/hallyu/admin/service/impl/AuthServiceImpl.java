// spr/com/hallyu/admin/service/impl/AuthServiceImpl.java
package spr.com.hallyu.admin.service.impl;

import java.util.Map;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import spr.com.hallyu.admin.service.AuthService;
import spr.com.hallyu.admin.mapper.AdminUserMapper;

@Service
public class AuthServiceImpl implements AuthService {
  @Resource private AdminUserMapper adminUserMapper;

  @Override
  public Map<String, Object> login(String username, String password) {
    // DB에서 사용자 정보(비밀번호, 역할 포함)를 가져옵니다.
    Map<String, Object> user = adminUserMapper.findByUsernameForAuth(username);

    // 사용자 정보가 있고 비밀번호가 일치하면 사용자 정보를 반환합니다.
    if (user != null && password.equals(user.get("password"))) { // 중요: 운영 환경에서는 BCrypt.checkpw 와 같은 암호화된 비교를 해야 합니다.
      return user;
    }
    return null;
  }

  @Override
  public void logout(javax.servlet.http.HttpSession session) {
    session.invalidate();
  }
}
