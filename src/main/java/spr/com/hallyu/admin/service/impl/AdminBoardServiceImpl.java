package spr.com.hallyu.admin.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import spr.com.hallyu.admin.mapper.AdminBoardMapper; // AdminBoardMapper 사용
import spr.com.hallyu.admin.model.AdminBoardPost; // AdminBoardPost 모델 사용
import spr.com.hallyu.admin.service.AdminBoardService; // AdminBoardService 구현
import spr.com.hallyu.board.model.BoardPost;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AdminBoardServiceImpl implements AdminBoardService {

    private final AdminBoardMapper adminBoardMapper; // AdminBoardMapper 주입

    @Autowired
    public AdminBoardServiceImpl(AdminBoardMapper adminBoardMapper) {
        this.adminBoardMapper = adminBoardMapper;
    }

    @Override
    public List<AdminBoardPost> getPostsByCategory(String categoryCode, int limit, int offset) {
        Map<String, Object> params = new HashMap<>();
        params.put("categoryCode", categoryCode);
        params.put("limit", limit);
        params.put("offset", offset);
        return adminBoardMapper.findPostsByCategory(params);
    }

    @Override
    public int getTotalPostsCount(String categoryCode) {
        return adminBoardMapper.countPostsByCategory(categoryCode);
    }
    
    @Override
    public AdminBoardPost findOne(Long id, boolean increaseViewCount) {
        if (increaseViewCount) {
            adminBoardMapper.increaseViewCount(id);
        }
        return adminBoardMapper.findOne(id);
    }

    @Override
    public void writePost(AdminBoardPost post) {
    	adminBoardMapper.insertPost(post);
    }

    
    @Override
    public void updatePost(AdminBoardPost post) {
        adminBoardMapper.updatePost(post);
    }
    
    @Override
    public void deletePost(AdminBoardPost post) {
        adminBoardMapper.deletePost(post);
    }
    
  
    
}
