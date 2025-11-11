// spr/com/hallyu/admin/service/AuthService.java
package spr.com.hallyu.admin.service;

import java.util.Map;

public interface AuthService {
 
  Map<String, Object> login(String username, String password);
  void logout(javax.servlet.http.HttpSession session);
}
