package spr.com.hallyu.comment.service;


import java.util.List;

import spr.com.hallyu.common.utils.CamelMap;

public interface CommentService {
    List<CamelMap> getCommentsByPostId(Long postId);
    CamelMap addComment(CamelMap comment);
    CamelMap updateComment(CamelMap comment);
    void deleteComment(Long commentId, String writerId);
}

