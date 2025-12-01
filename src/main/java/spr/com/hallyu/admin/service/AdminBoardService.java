package spr.com.hallyu.admin.service;

import spr.com.hallyu.admin.model.AdminBoardPost; // AdminBoardPost 모델 사용
import spr.com.hallyu.board.model.BoardPost;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public interface AdminBoardService {
    List<AdminBoardPost> getPostsByCategory(String categoryCode, int limit, int offset);
    int getTotalPostsCount(String categoryCode);
    AdminBoardPost findOne(Long id, boolean increaseViewCount);
    void updatePost(AdminBoardPost post,List<MultipartFile> files, List<Long> deleteFileIds);
    void writePost(AdminBoardPost post,List<MultipartFile> files, List<Long> deleteFileIds);
    void deletePost(AdminBoardPost post);
    
}
