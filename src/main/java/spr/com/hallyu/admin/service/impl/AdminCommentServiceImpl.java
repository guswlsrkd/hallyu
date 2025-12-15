package spr.com.hallyu.admin.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import spr.com.hallyu.admin.mapper.AdminBoardMapper; // AdminBoardMapper 사용
import spr.com.hallyu.admin.mapper.AdminCommentMapper;
import spr.com.hallyu.admin.model.AdminBoardPost; // AdminBoardPost 모델 사용
import spr.com.hallyu.admin.service.AdminBoardService; // AdminBoardService 구현
import spr.com.hallyu.admin.service.AdminCommentService;
import spr.com.hallyu.board.model.BoardPost;
import spr.com.hallyu.common.utils.CamelMap;
import spr.com.hallyu.file.model.Attachment;
import spr.com.hallyu.file.mapper.AttachmentMapper;
import javax.servlet.ServletContext;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@Transactional // 클래스 레벨에 트랜잭션 선언
public class AdminCommentServiceImpl implements AdminCommentService {

    private final AdminCommentMapper adminCommentMapper;
  
    
    @Autowired
    private ServletContext servletContext;
    
    private String uploadPath;

    @Autowired
    public AdminCommentServiceImpl(AdminCommentMapper adminCommentMapper) {
        this.adminCommentMapper = adminCommentMapper;
      
    }
    
    @Override
    public List<CamelMap> getCommentsByPostId(Long postId) {
    	
		/*
		 * List<CamelMap> result = new ArrayList<>(); List<CamelMap> flatList =
		 * adminCommentMapper.selectCommentsByPostId(postId); for(CamelMap commentList :
		 * flatList) { System.out.println(commentList.get("id"));
		 * result.add(commentList); List<CamelMap> parentComment =
		 * adminCommentMapper.selectCommentsByParentId((long)commentList.get("id"));
		 * if(parentComment.size()>0) {
		 * System.out.println("parentComment : "+parentComment); for(CamelMap
		 * parentResult : parentComment) { result.add(parentResult); } } } return
		 * result;
		 */
    	
    	List<CamelMap> flatList = adminCommentMapper.selectCommentsByPostId(postId);
        
        // 결과를 담을 리스트 (LinkedHashMap을 사용하여 순서 보장)
        Map<Long, CamelMap> commentMap = new LinkedHashMap<>();

        // 1. 모든 댓글을 맵에 추가하고, 각 댓글에 자식 리스트를 초기화합니다.
        for (CamelMap comment : flatList) {
            comment.put("replies", new ArrayList<CamelMap>());
            commentMap.put(Long.valueOf(comment.get("id").toString()), comment);
        }

        // 2. 답글을 부모 댓글의 자식 리스트에 추가합니다.
        commentMap.values().stream()
            .filter(comment -> comment.get("parentId") != null)
            .forEach(reply -> {
                CamelMap parent = commentMap.get(Long.valueOf(reply.get("parentId").toString()));
                if (parent != null) {
                    ((List<CamelMap>) parent.get("replies")).add(reply);
                }
            });

        // 3. 최상위 댓글(원 댓글)만 필터링하여 최종 리스트를 생성합니다.
        return commentMap.values().stream()
            .filter(comment -> comment.get("parentId") == null)
            .collect(Collectors.toList());
    	
    	
    }
    
    @Override
	@Transactional public CamelMap addComment(CamelMap comment) {
    	adminCommentMapper.insertComment(comment); return comment; 
	}
    
    @Override
	@Transactional
	public CamelMap updateComment(CamelMap comment) {
    	adminCommentMapper.updateComment(comment);
	    return comment; // 컨트롤러에 수정된 내용을 다시 전달
	}
	
	@Override
	@Transactional 
	public void deleteComment(Long commentId, String writerId) {
		adminCommentMapper.deleteComment(commentId, writerId); 
	}

    
}
