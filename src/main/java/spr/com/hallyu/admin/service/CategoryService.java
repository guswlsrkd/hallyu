package spr.com.hallyu.admin.service;

import java.util.List;
import spr.com.hallyu.board.model.BoardCategory;

public interface CategoryService {
  List<BoardCategory> findAll();                // flat
  List<BoardCategory> findTreeFlat();           // depth 순서로 플랫(들여쓰기용)
  BoardCategory findOne(String code);

  void create(BoardCategory c);                 // 새 항목(최대 sort+1)
  void update(BoardCategory c);                 // 수정
  void delete(String code);                     // 자식 있으면 예외

  void moveUp(String code);                     // 같은 부모 내 위로
  void moveDown(String code);                   // 같은 부모 내 아래로
}
