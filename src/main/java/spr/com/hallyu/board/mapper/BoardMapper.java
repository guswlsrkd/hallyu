// src/main/java/spr/com/hallyu/board/mapper/BoardMapper.java
package spr.com.hallyu.board.mapper;

import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

import spr.com.hallyu.board.model.BoardCategory;
import spr.com.hallyu.board.model.BoardPost;

public interface BoardMapper {
  long countByCode(@Param("code") String code);

  List<BoardPost> findPageByCode(@Param("code") String code,
                                 @Param("limit") int limit,
                                 @Param("offset") int offset);

  BoardPost findOne(@Param("id") Long id);

  void insertPost(BoardPost post);
  void updatePost(BoardPost post);
  int deletePost(@Param("id") Long id);

  int increaseViews(@Param("id") Long id);
  
  BoardCategory findByPath(@Param("path") String path);
  BoardCategory findByCode(@Param("code") String code);
  
  List<BoardPost> findPostsByCategory(Map<String, Object> param);
  int countPostsByCategory(String categoryCode);
}
