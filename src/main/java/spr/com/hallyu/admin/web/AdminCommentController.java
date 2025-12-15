package spr.com.hallyu.admin.web;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import lombok.RequiredArgsConstructor;
import spr.com.hallyu.admin.service.CategoryService;
import spr.com.hallyu.board.model.BoardPost;
import spr.com.hallyu.board.service.BoardService;
import spr.com.hallyu.comment.service.CommentService;
import spr.com.hallyu.common.utils.CamelMap;
import spr.com.hallyu.file.model.Attachment;
import spr.com.hallyu.admin.model.AdminBoardPost; // AdminBoardPost 모델 사용
import spr.com.hallyu.admin.service.AdminBoardService; // AdminBoardService 사용
import spr.com.hallyu.admin.service.AdminCommentService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin/api/comments")
public class AdminCommentController {
	
	
	 private final AdminCommentService adminCommentService;
	 
	 @Autowired
	 public AdminCommentController(AdminCommentService adminCommentService) {
		 this.adminCommentService = adminCommentService;
	 }


	/**
     * 특정 게시글의 댓글 목록 조회
     */
    @GetMapping("/post/{postId}")
    public ResponseEntity<List<CamelMap>> getCommentsByPostId(@PathVariable Long postId) {
        List<CamelMap> comments = adminCommentService.getCommentsByPostId(postId);
        return ResponseEntity.ok(comments);
    }
    
    /**
     * 댓글 생성
     */
	
	@PostMapping
	public ResponseEntity<CamelMap> addComment(@RequestBody CamelMap commentPara, HttpSession session) { 
		  System.out.println("댓글 등록 API 컨트롤러 진입");

		  // security="none" 경로에서는 SecurityContextHolder가 동작하지 않으므로,
		  // AdminAuthController에서 로그인 시 저장한 세션 정보를 직접 사용합니다.
		  String writerId = (String) session.getAttribute("ADMIN_LOGIN");
		  
		  // 세션에 로그인 정보가 있는지 확인
		  if (writerId == null || writerId.isEmpty()) {
			  throw new AccessDeniedException("로그인 후 댓글을 작성할 수 있습니다."); 
		  }
		  
		  // 파라미터에 작성자 ID 추가
		  commentPara.put("writerId",writerId);
	  
		  CamelMap createdComment = adminCommentService.addComment(commentPara); 
		  
		  return ResponseEntity.ok(createdComment); 
	}
	
	 /*** 댓글 수정*/
	 @PutMapping("/{commentId}")
	 public ResponseEntity<CamelMap> updateComment(@PathVariable Long commentId, 
			                                       @RequestBody CamelMap commentPara,
			                                       HttpSession session) {
		 
		     String writerId = (String) session.getAttribute("ADMIN_LOGIN");
		  
			 // 세션에 로그인 정보가 있는지 확인
			 if (writerId == null || writerId.isEmpty()) {
				  throw new AccessDeniedException("로그인 후 댓글을 작성할 수 있습니다."); 
			 }
			   
		    

		     // TODO: 서비스 레이어에서 수정 권한을 확인하는 로직 추가 (현재는 컨트롤러에서 처리)
		     commentPara.put("id", commentId);
		     CamelMap updatedComment = adminCommentService.updateComment(commentPara);
		     return ResponseEntity.ok(updatedComment);
	 } 
	 
	 /**
	     * 댓글 삭제
	     */
		
	@DeleteMapping("/{commentId}") 
	public ResponseEntity<Map<String, Object>>deleteComment(@PathVariable Long commentId,HttpSession session) {
			  
		 String writerId = (String) session.getAttribute("ADMIN_LOGIN");
		  
		 // 세션에 로그인 정보가 있는지 확인
		 if (writerId == null || writerId.isEmpty()) {
			  throw new AccessDeniedException("로그인 후 댓글을 작성할 수 있습니다."); 
		 }	  
		
		// 관리자는 writerId 없이 삭제, 일반 사용자는 본인 댓글만 삭제
		adminCommentService.deleteComment(commentId, true ? null : "admin");
		  
		Map<String, Object> response = new HashMap<>(); response.put("success",true); 
			  
		return ResponseEntity.ok(response); 
	}	  
}
