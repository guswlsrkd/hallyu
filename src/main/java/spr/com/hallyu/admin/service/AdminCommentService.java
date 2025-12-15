package spr.com.hallyu.admin.service;

import spr.com.hallyu.admin.model.AdminBoardPost; // AdminBoardPost 모델 사용
import spr.com.hallyu.board.model.BoardPost;
import spr.com.hallyu.common.utils.CamelMap;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public interface AdminCommentService {
	 List<CamelMap> getCommentsByPostId(Long postId);
	 CamelMap addComment(CamelMap comment);
	 CamelMap updateComment(CamelMap comment);
	 void deleteComment(Long commentId, String writerId);
}
