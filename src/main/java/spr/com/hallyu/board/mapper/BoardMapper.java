// src/main/java/spr/com/hallyu/board/mapper/BoardMapper.java
package spr.com.hallyu.board.mapper;

import org.apache.ibatis.annotations.Param;
import java.util.List;
import spr.com.hallyu.board.model.BoardPost;

public interface BoardMapper {
  long countByCode(@Param("code") String code);

  List<BoardPost> findPageByCode(@Param("code") String code,
                                 @Param("limit") int limit,
                                 @Param("offset") int offset);

  BoardPost findOne(@Param("id") Long id);

  int insertPost(BoardPost p);
  int updatePost(BoardPost p);
  int deletePost(@Param("id") Long id);

  int increaseViews(@Param("id") Long id);
}
