// spr/com/hallyu/admin/service/impl/AuthServiceImpl.java
package spr.com.hallyu.admin.service.impl;

import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import spr.com.hallyu.admin.service.AuthService;
import spr.com.hallyu.admin.mapper.AdminUserMapper;

@Service
public class AuthServiceImpl implements AuthService {
  @Resource private AdminUserMapper adminUserMapper;

  @Override
  public boolean login(String username, String password) {
    String dbPw = adminUserMapper.findPasswordByUsername(username);
    return dbPw != null && dbPw.equals(password); // 데모용. 운영은 BCrypt.checkpw
  }

  @Override
  public void logout(javax.servlet.http.HttpSession session) {
    session.invalidate();
  }
}
