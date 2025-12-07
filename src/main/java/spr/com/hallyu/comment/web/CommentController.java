package spr.com.hallyu.comment.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
//import spr.com.hallyu.board.model.Comment;
import spr.com.hallyu.comment.service.CommentService;
import spr.com.hallyu.common.utils.CamelMap;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/comments") // 댓글 관련 API를 위한 공통 경로
public class CommentController {

    private final CommentService commentService;

    @Autowired
    public CommentController(CommentService commentService) {
        this.commentService = commentService;
    }

    /**
     * 특정 게시글의 댓글 목록 조회
     */
    @GetMapping("/post/{postId}")
    public ResponseEntity<List<CamelMap>> getCommentsByPostId(@PathVariable Long postId) {
        List<CamelMap> comments = commentService.getCommentsByPostId(postId);
        return ResponseEntity.ok(comments);
    }

    /**
     * 댓글 생성
     */
	
	  @PostMapping 
	  public ResponseEntity<CamelMap> addComment(@RequestBody CamelMap commentPara) { 
		  System.out.println("ddfdfdfd11111");
		  Authentication authentication = SecurityContextHolder.getContext().getAuthentication(); 
		  
		  if (authentication == null || "anonymousUser".equals(authentication.getName())) { 
			  throw new AccessDeniedException("로그인 후 댓글을 작성할 수 있습니다."); 
		  } 
		  String writerId = authentication.getName(); 
		  //comment.setWriterId(writerId);
		  commentPara.put("writerId",writerId);
	  
		  CamelMap createdComment = commentService.addComment(commentPara); 
		  
		  return ResponseEntity.ok(createdComment); 
	 }
	 
	  /*** 댓글 수정*/
	 @PutMapping("/{commentId}")
	 public ResponseEntity<CamelMap> updateComment(@PathVariable Long commentId, @RequestBody CamelMap commentPara) {
		     Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		     String currentUsername = authentication.getName();
		     boolean isAdmin = authentication.getAuthorities().stream()
		             .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

		     // TODO: 서비스 레이어에서 수정 권한을 확인하는 로직 추가 (현재는 컨트롤러에서 처리)
		     commentPara.put("id", commentId);
		     CamelMap updatedComment = commentService.updateComment(commentPara);
		     return ResponseEntity.ok(updatedComment);
	  } 
    /**
     * 댓글 삭제
     */
	
	  @DeleteMapping("/{commentId}") 
	  public ResponseEntity<Map<String, Object>>deleteComment(@PathVariable Long commentId) {
		  
		  
		  Authentication authentication = SecurityContextHolder.getContext().getAuthentication(); 
		  String currentUsername = authentication.getName(); 
		  boolean isAdmin = authentication.getAuthorities().stream() .anyMatch(a ->a.getAuthority().equals("ROLE_ADMIN"));
	  
		  // 관리자는 writerId 없이 삭제, 일반 사용자는 본인 댓글만 삭제
		  commentService.deleteComment(commentId, isAdmin ? null : currentUsername);
	  
		  Map<String, Object> response = new HashMap<>(); response.put("success",true); 
		  
		  return ResponseEntity.ok(response); }	 
}
