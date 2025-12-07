package spr.com.hallyu.comment.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import spr.com.hallyu.common.utils.CamelMap;

import java.util.List;

@Mapper
public interface CommentMapper {
    void insertComment(CamelMap comment);
    List<CamelMap> selectCommentsByPostId(Long postId);
    void updateComment(CamelMap comment);
    void deleteComment(@Param("id") Long id, @Param("writerId") String writerId);
}

