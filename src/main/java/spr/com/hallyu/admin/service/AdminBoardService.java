package spr.com.hallyu.admin.service;

import spr.com.hallyu.admin.model.AdminBoardPost; // AdminBoardPost 모델 사용
import spr.com.hallyu.board.model.BoardPost;

import java.util.List;

public interface AdminBoardService {
    List<AdminBoardPost> getPostsByCategory(String categoryCode, int limit, int offset);
    int getTotalPostsCount(String categoryCode);
    AdminBoardPost findOne(Long id, boolean increaseViewCount);
    void updatePost(AdminBoardPost post);
    void writePost(AdminBoardPost post);
    void deletePost(AdminBoardPost post);
    
}
