package spr.com.hallyu.admin.service.impl;

import lombok.RequiredArgsConstructor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import spr.com.hallyu.admin.mapper.MemberMapper;
import spr.com.hallyu.admin.service.MemberService;

import java.util.*;

@Service
public class MemberServiceImpl implements MemberService {

    private final MemberMapper mapper;

    @Autowired
    public MemberServiceImpl(MemberMapper mapper) {
        this.mapper = mapper;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Map<String, Object>> memberList() {
        return mapper.memberList();
    }

    /**
     * 사용자의 메뉴 권한 코드 목록을 조회합니다.
     * @param username 사용자 아이디
     * @return 메뉴 코드 리스트
     */
    @Override
    public List<String> getMenuPermissions(String userId) {
        return mapper.findMenuPermissions(userId);
    }

    /**
     * 사용자의 메뉴 권한을 저장합니다. (기존 권한 삭제 후 새로 추가)
     * @param username 사용자 아이디
     * @param categoryCodes 저장할 메뉴 코드 리스트
     */
    @Override
    @Transactional
    public void saveMenuPermissions(String userId, List<String> categoryCodes) {
        mapper.deleteMenuPermissions(userId); // 1. 기존 권한을 모두 삭제
        if (categoryCodes != null && !categoryCodes.isEmpty()) {
            mapper.insertMenuPermissions(userId, categoryCodes); // 2. 새로운 권한 목록을 한번에 추가
        }
    }
}
