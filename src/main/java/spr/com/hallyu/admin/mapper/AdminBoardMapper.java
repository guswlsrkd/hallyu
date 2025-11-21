package spr.com.hallyu.admin.mapper;

import org.apache.ibatis.annotations.Mapper;
import spr.com.hallyu.admin.model.AdminBoardPost; // AdminBoardPost 모델 사용
import spr.com.hallyu.board.model.BoardPost;

import java.util.List;
import java.util.Map;

@Mapper
public interface AdminBoardMapper {
    List<AdminBoardPost> findPostsByCategory(Map<String, Object> params);
    int countPostsByCategory(String categoryCode);
    AdminBoardPost findOne(Long id);
    void insertPost(AdminBoardPost post);
    void updatePost(AdminBoardPost post);
    void increaseViewCount(Long id);
    void deletePost(AdminBoardPost post);
    
}
