// spr/com/hallyu/admin/service/AuthService.java
package spr.com.hallyu.admin.service;

public interface AuthService {
  boolean login(String username, String password);
  void logout(javax.servlet.http.HttpSession session);
}
