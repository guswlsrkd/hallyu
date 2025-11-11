package spr.com.hallyu.admin.service.impl;

import lombok.RequiredArgsConstructor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import spr.com.hallyu.admin.mapper.AdminCategoryMapper;
import spr.com.hallyu.admin.service.CategoryService;

import java.util.*;

@Service
@RequiredArgsConstructor
public class CategoryServiceImpl implements CategoryService {

    private final AdminCategoryMapper mapper;
    
    @Autowired
    public CategoryServiceImpl(AdminCategoryMapper mapper) {
        this.mapper = mapper;   // <-- final 채움
    }

    /** 트리를 플랫하게(depth 필드로 들여쓰기 표현) */
    @Override
    @Transactional(readOnly = true)
    public List<Map<String, Object>> findTreeFlat() {
        List<Map<String,Object>> result = new ArrayList<>();
        // 최상위부터 DFS
        List<Map<String,Object>> tops = mapper.findTopList();
        for (Map<String,Object> top : tops) {
            result.add(top);
            dfsAppend((String) top.get("code"), result);
        }
        return result;
    }

    private void dfsAppend(String parentCode, List<Map<String,Object>> acc) {
        List<Map<String,Object>> children = mapper.findChildren(parentCode);
        for (Map<String,Object> ch : children) {
            acc.add(ch);
            dfsAppend((String)ch.get("code"), acc);
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
