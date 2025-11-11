package spr.com.hallyu.admin.service;

import java.util.*;
import spr.com.hallyu.board.model.BoardCategory;

public interface CategoryService {
    List<Map<String,Object>> findTreeFlat(); // depth 기준 플랫 트리
    Map<String,Object> findOne(String code);

    void create(Map<String,Object> dto);      // code, name, path, parentCode?
    void update(Map<String,Object> dto);      // code, name, path, useYn, visible
    void delete(String code);                 // 하위 먼저 삭제

    void moveUp(String code);
    void moveDown(String code);

    void toggleVisible(String code, String visibleYorN);
    void createChild(Map<String,Object> dto);  // ← 이 줄 추가

    void reorder(String parentCode, List<String> orderedCodes); // 같은 부모 내에서 순서 저장
}
