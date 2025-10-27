package spr.com.hallyu.admin.mapper;

import java.util.List;
import java.util.Map;
import spr.com.hallyu.board.model.BoardCategory;

public interface AdminCategoryMapper {
  List<BoardCategory> findAll();
  BoardCategory findOne(String code);
  List<BoardCategory> findChildren(String parentCode);
  int findMaxSortByParent(String parentCode);

  int insert(BoardCategory c);
  int update(BoardCategory c);
  int delete(String code);

  int updateSort(Map<String,Object> params);
  int countChildren(String code);
}
