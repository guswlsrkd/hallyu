package spr.com.hallyu.category.mapper;

import java.util.List;
import spr.com.hallyu.board.model.BoardCategory;

public interface CategoryMapper {
  List<BoardCategory> findTopMenus();
  List<BoardCategory> findChildren(String parentCode);
}
