// src/main/java/spr/com/hallyu/board/service/BoardService.java
package spr.com.hallyu.board.service;

import java.util.List;

import spr.com.hallyu.board.model.BoardCategory;
import spr.com.hallyu.board.model.BoardPost;
import spr.com.hallyu.board.model.PageResult;

public interface BoardService {
  long countByCode(String code);
  List<BoardPost> findPageByCode(String code, int page, int size);
  PageResult<BoardPost> page(String code, int page, int size);

  BoardPost findOne(Long id, boolean increaseView);
  void delete(Long id);
  
  List<BoardPost> findPostsByCategory(String categoryCode, int offset, int limit);
  int countPostsByCategory(String categoryCode);
  
  BoardCategory findByPath(String path);   // /k-food 같은 path로 조회
  BoardCategory findByCode(String code);   // cat=code 로 조회
  void writePost(BoardPost post);
  void updatePost(BoardPost post);
}
