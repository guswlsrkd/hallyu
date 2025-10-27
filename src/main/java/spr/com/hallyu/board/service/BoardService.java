// src/main/java/spr/com/hallyu/board/service/BoardService.java
package spr.com.hallyu.board.service;

import java.util.List;
import spr.com.hallyu.board.model.BoardPost;
import spr.com.hallyu.board.model.PageResult;

public interface BoardService {
  long countByCode(String code);
  List<BoardPost> findPageByCode(String code, int page, int size);
  PageResult<BoardPost> page(String code, int page, int size);

  BoardPost findOne(Long id, boolean increaseView);
  Long save(BoardPost p);     // insert/update 자동 분기
  void delete(Long id);
}
