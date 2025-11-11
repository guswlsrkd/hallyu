// spr/com/hallyu/admin/mapper/AdminUserMapper.java
package spr.com.hallyu.admin.mapper;

import java.util.Map;
import org.apache.ibatis.annotations.Param;

public interface AdminUserMapper {
  String findPasswordByUsername(String username);
  //int existsByEmail(@Param("email") String email);
  int existsByUsername(@Param("username") String username);

  Map<String, Object> findByUsernameForAuth(String username);
}
