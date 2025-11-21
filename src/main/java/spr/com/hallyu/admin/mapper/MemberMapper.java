package spr.com.hallyu.admin.mapper;

import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface MemberMapper {
    
    List<Map<String,Object>> memberList();
   
    List<String> findMenuPermissions(String userId);

    void deleteMenuPermissions(String userId);

    void insertMenuPermissions(@Param("userId") String userId, @Param("categoryCodes") List<String> categoryCodes);
}
