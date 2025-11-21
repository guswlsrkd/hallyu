package spr.com.hallyu.admin.service.impl;

import lombok.RequiredArgsConstructor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import spr.com.hallyu.admin.mapper.AdminCategoryMapper;
import spr.com.hallyu.admin.service.CategoryService;

import java.util.*;

@Service
public class CategoryServiceImpl implements CategoryService {

    private final AdminCategoryMapper mapper;

    @Autowired
    public CategoryServiceImpl(AdminCategoryMapper mapper) {
        this.mapper = mapper;
    }

    /** 트리를 플랫하게(depth 필드로 들여쓰기 표현) */
    @Override
    @Transactional(readOnly = true)
    public List<Map<String, Object>> findTreeFlat() {
        List<Map<String,Object>> result = new ArrayList<>();
        List<Map<String,Object>> topLevelNodes = mapper.findTopList();
        for (Map<String,Object> node : topLevelNodes) {
            node.put("depth", 0); // 최상위 노드의 깊이는 0
            result.add(node);
            // 자식 노드들을 찾아서 결과 리스트에 추가
            findAndAddChildren(result, (String) node.get("code"), 1);
        }
        return result;
    }

    /**
     * 특정 부모의 자식 노드를 재귀적으로 찾아 리스트에 추가하는 헬퍼 메소드
     */
    private void findAndAddChildren(List<Map<String, Object>> resultList, String parentCode, int depth) {
        // 무한 재귀 방지: parentCode가 null이거나 비어있으면 더 이상 탐색하지 않음
        if (parentCode == null || parentCode.isEmpty()) {
            return;
        }
        List<Map<String,Object>> children = mapper.findChildren(parentCode);
        for (Map<String,Object> ch : children) {
            ch.put("depth", depth); // 현재 깊이 설정
            resultList.add(ch); // 결과 리스트에 직접 추가
            findAndAddChildren(resultList, (String)ch.get("code"), depth + 1); // 더 깊은 자식 탐색
        }
    }

    @Override
    public Map<String, Object> findOne(String code) {
        return mapper.findOne(code);
    }

    @Override
    @Transactional
    public void create(Map<String, Object> dto) {
        String parentCode = (String) dto.get("parentCode");
        Integer max = mapper.findMaxSortOrder(parentCode);
        int sortOrder = (max == null ? 0 : max) + 1;

        int depth = 0;
        if (parentCode != null) {
            Map<String,Object> parent = mapper.findOne(parentCode);
            depth = parent == null ? 0 : ((Number)parent.get("depth")).intValue() + 1;
        }

        dto.put("sortOrder", sortOrder);
        dto.put("depth", depth);
        mapper.insert(dto);
    }

    @Override
    @Transactional
    public void update(Map<String, Object> dto) {
        mapper.update(dto);
    }
    
    @Override
    public void createChild(Map<String,Object> dto) {
        // 부모 코드에서 depth, sort_order 계산
        String parentCode = (String) dto.get("parentCode");
        Integer parentDepth = mapper.findDepth(parentCode);
        int depth = (parentDepth == null ? 1 : parentDepth + 1);
        int sortOrder = mapper.nextSortOrder(parentCode);

        // visible/useYn 보정
        String visible = String.valueOf(dto.getOrDefault("visible", "Y"));
        String useYn = String.valueOf(dto.getOrDefault("useYn", "Y"));

        dto.put("depth", depth);
        dto.put("sortOrder", sortOrder);
        dto.put("visible", ("Y".equalsIgnoreCase(visible) ? "Y" : "N"));
        dto.put("useYn", ("Y".equalsIgnoreCase(useYn) ? "Y" : "N"));

        mapper.insertChild(dto);
    }

    @Override
    @Transactional
    public void delete(String code) {
        // 자식부터 삭제 (재귀 CTE가 안되면 findChildren로 재귀)
        // 여기서는 CTE 사용 가정: findAllDescendants
        List<String> descendants = mapper.findAllDescendants(code);
        // 하위부터 삭제
        Collections.reverse(descendants);
        for (String c : descendants) mapper.delete(c);
        mapper.delete(code);
    }

    @Override
    @Transactional
    public void moveUp(String code) {
        Map<String,Object> me = mapper.findOne(code);
        if (me == null) return;

        String parentCode = (String) me.get("parent_code");
        int myOrder = ((Number) me.get("sort_order")).intValue();

        // 이전 형제 찾기
        List<Map<String,Object>> siblings = mapper.findChildren(parentCode);
        Map<String,Object> prev = null;
        for (Map<String,Object> s : siblings) {
            int o = ((Number)s.get("sort_order")).intValue();
            if (o < myOrder) prev = s;
        }
        if (prev == null) return;

        mapper.swapSortOrder(
                code,
                (String) prev.get("code"),
                myOrder,
                ((Number)prev.get("sort_order")).intValue()
        );
    }

    @Override
    @Transactional
    public void moveDown(String code) {
        Map<String,Object> me = mapper.findOne(code);
        if (me == null) return;
System.out.println("ddddddddddddddddddd");
        String parentCode = (String) me.get("parent_code");
        int myOrder = ((Number) me.get("sort_order")).intValue();

        List<Map<String,Object>> siblings = mapper.findChildren(parentCode);
        Map<String,Object> next = null;
        for (int i=0; i<siblings.size(); i++) {
            Map<String,Object> s = siblings.get(i);
            int o = ((Number)s.get("sort_order")).intValue();
            System.out.println("myOrder : "+myOrder);
            System.out.println("siblings.size() : "+siblings.size());
            if (o == myOrder && i+1 < siblings.size()) {
                next = siblings.get(i+1);
                break;
            }
        }
        System.out.println("next : "+next);
        System.out.println("11111111111111111111");
        if (next == null) return;
        System.out.println("22222222222222222222222");
        mapper.swapSortOrder(
                code,
                (String) next.get("code"),
                myOrder,
                ((Number)next.get("sort_order")).intValue()
        );
    }

    @Override
    @Transactional
    public void toggleVisible(String code, String visibleYorN) {
        Map<String,Object> p = new HashMap<>();
        p.put("code", code);
        p.put("visible", "Y".equalsIgnoreCase(visibleYorN) ? "Y" : "N");
        mapper.toggleVisible(p);
    }

    @Override
    @Transactional
    public void reorder(String parentCode, List<String> orderedCodes) {
        int order = 1;
        for (String code : orderedCodes) {
            Map<String,Object> p = new HashMap<>();
            p.put("code", code);
            p.put("sortOrder", order++);
            mapper.updateSortOrder(p);
        }
    }
}
