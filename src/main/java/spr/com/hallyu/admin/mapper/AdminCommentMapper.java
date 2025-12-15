package spr.com.hallyu.admin.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import spr.com.hallyu.admin.model.AdminBoardPost; // AdminBoardPost 모델 사용
import spr.com.hallyu.board.model.BoardPost;
import spr.com.hallyu.common.utils.CamelMap;

import java.util.List;
import java.util.Map;

@Mapper
public interface AdminCommentMapper {
	 List<CamelMap> selectCommentsByPostId(Long postId);
	 List<CamelMap> selectCommentsByParentId(Long id);
	 void insertComment(CamelMap comment);
	 void updateComment(CamelMap comment);
	 void deleteComment(@Param("id") Long id, @Param("writerId") String writerId);
    
}
