package spr.com.hallyu.comment.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import spr.com.hallyu.comment.mapper.CommentMapper;
import spr.com.hallyu.comment.service.CommentService;
import spr.com.hallyu.common.utils.CamelMap;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class CommentServiceImpl implements CommentService {

    private final CommentMapper commentMapper;

    @Autowired
    public CommentServiceImpl(CommentMapper commentMapper) {
        this.commentMapper = commentMapper;
    }

    @Override
    public List<CamelMap> getCommentsByPostId(Long postId) {
    	List<CamelMap> flatList = commentMapper.selectCommentsByPostId(postId);
        
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
		  commentMapper.insertComment(comment); return comment; 
	  }
	  
	  @Override
	  @Transactional
	  public CamelMap updateComment(CamelMap comment) {
	      commentMapper.updateComment(comment);
	      return comment; // 컨트롤러에 수정된 내용을 다시 전달
	  }
	
	  @Override
	  @Transactional 
	  public void deleteComment(Long commentId, String writerId) {
		  commentMapper.deleteComment(commentId, writerId); 
	  }
	 
	 
}

