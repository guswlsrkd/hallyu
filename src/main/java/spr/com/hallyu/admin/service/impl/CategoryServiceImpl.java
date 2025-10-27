package spr.com.hallyu.admin.service.impl;

import java.util.*;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import spr.com.hallyu.admin.mapper.AdminCategoryMapper;
import spr.com.hallyu.admin.service.CategoryService;
import spr.com.hallyu.board.model.BoardCategory;

@Service
@Transactional
public class CategoryServiceImpl implements CategoryService {

  @Resource private AdminCategoryMapper mapper;

  @Override @Transactional(readOnly = true)
  public List<BoardCategory> findAll() { return mapper.findAll(); }

  @Override @Transactional(readOnly = true)
  public BoardCategory findOne(String code) { return mapper.findOne(code); }

  @Override
  public void create(BoardCategory c) {
    int max = mapper.findMaxSortByParent(c.getParentCode());
    c.setSortOrder(max + 1);
    if (c.getUseYn() == null) c.setUseYn("Y");
    if (c.getVisible() == null) c.setVisible(true);
    if (c.getDepth() == null) c.setDepth(c.getParentCode() == null ? 0 : 1);
    mapper.insert(c);
  }

  @Override
  public void update(BoardCategory c) {
    mapper.update(c);
  }

  @Override
  public void delete(String code) {
    if (mapper.countChildren(code) > 0) {
      throw new IllegalStateException("자식 카테고리가 있어 삭제할 수 없습니다.");
    }
    mapper.delete(code);
  }

  @Override
  public void moveUp(String code) {
    BoardCategory cur = mapper.findOne(code);
    if (cur == null) return;
    String parent = cur.getParentCode();
    List<BoardCategory> siblings = mapper.findChildren(parent);
    BoardCategory prev = null;
    for (BoardCategory s : siblings) {
      if (Objects.equals(s.getCode(), cur.getCode())) break;
      prev = s;
    }
    if (prev == null) return;
    swapSort(prev, cur);
  }

  @Override
  public void moveDown(String code) {
    BoardCategory cur = mapper.findOne(code);
    if (cur == null) return;
    String parent = cur.getParentCode();
    List<BoardCategory> siblings = mapper.findChildren(parent);
    for (int i = 0; i < siblings.size(); i++) {
      if (Objects.equals(siblings.get(i).getCode(), cur.getCode())) {
        if (i < siblings.size() - 1) {
          swapSort(cur, siblings.get(i + 1));
        }
        return;
      }
    }
  }

  private void swapSort(BoardCategory a, BoardCategory b) {
    Map<String,Object> p1 = new HashMap<>();
    p1.put("code", a.getCode()); p1.put("sortOrder", b.getSortOrder());
    Map<String,Object> p2 = new HashMap<>();
    p2.put("code", b.getCode()); p2.put("sortOrder", a.getSortOrder());
    mapper.updateSort(p1);
    mapper.updateSort(p2);
  }

  @Override @Transactional(readOnly = true)
  public List<BoardCategory> findTreeFlat() {
    // flat 전체 → parent_code 기준으로 트리 → depth 순서로 플랫
    List<BoardCategory> all = mapper.findAll();
    Map<String, List<BoardCategory>> byParent = new HashMap<>();
    for (BoardCategory c : all) {
      byParent.computeIfAbsent(c.getParentCode(), k -> new ArrayList<>()).add(c);
    }
    // 자식들 sort_order 보장
    for (List<BoardCategory> list : byParent.values()) {
      list.sort(Comparator.comparingInt(BoardCategory::getSortOrder).thenComparing(BoardCategory::getName));
    }
    List<BoardCategory> flat = new ArrayList<>();
    render(byParent, null, flat);
    return flat;
  }

  private void render(Map<String,List<BoardCategory>> byParent, String parent, List<BoardCategory> out) {
    List<BoardCategory> children = byParent.get(parent);
    if (children == null) return;
    for (BoardCategory c : children) {
      out.add(c);
      render(byParent, c.getCode(), out);
    }
  }
}
