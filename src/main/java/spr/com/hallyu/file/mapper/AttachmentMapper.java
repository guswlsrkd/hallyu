// src/main/java/spr/com/hallyu/board/mapper/BoardMapper.java
package spr.com.hallyu.file.mapper;

import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import spr.com.hallyu.file.model.Attachment;

public interface AttachmentMapper {
    void insertAttachments(@Param("attachments") List<Attachment> attachments);
    List<Attachment> findByPostId(@Param("postId") Long postId);
    Attachment findById(@Param("id") Long id);
    List<Attachment> findByIds(@Param("ids") List<Long> ids);
    void deleteAttachments(@Param("ids") List<Long> ids);
}
