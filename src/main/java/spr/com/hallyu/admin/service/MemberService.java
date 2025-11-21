package spr.com.hallyu.admin.service;

import java.util.*;

import org.springframework.transaction.annotation.Transactional;

import spr.com.hallyu.board.model.BoardCategory;

public interface MemberService {
    List<Map<String,Object>> memberList(); // depth 기준 플랫 트리
    
    List<String> getMenuPermissions(String username);

    void saveMenuPermissions(String username, List<String> categoryCodes);
}
