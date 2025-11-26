// src/main/java/spr/com/hallyu/board/service/impl/BoardServiceImpl.java
package spr.com.hallyu.board.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.ServletContext;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import spr.com.hallyu.board.mapper.BoardMapper;
import spr.com.hallyu.board.model.BoardCategory;
import spr.com.hallyu.board.model.BoardPost;
import spr.com.hallyu.board.model.PageResult;
import spr.com.hallyu.board.service.BoardService;
import spr.com.hallyu.file.mapper.AttachmentMapper;
import spr.com.hallyu.file.model.Attachment;

import java.io.File;
import java.util.UUID;

@Service
@Transactional
public class BoardServiceImpl implements BoardService {

  @Resource
  private BoardMapper boardMapper;
  
  @Resource
  private AttachmentMapper attachmentMapper;
  
  @Autowired
  private ServletContext servletContext;
  
  private String uploadPath;

  @Override
  @Transactional(readOnly = true)
  public long countByCode(String code) {
    return boardMapper.countByCode(code);
  }

  @Override
  @Transactional(readOnly = true)
  public List<BoardPost> findPageByCode(String code, int page, int size) {
    int p = Math.max(1, page);
    int s = Math.max(1, size);
    int offset = (p - 1) * s;
    return boardMapper.findPageByCode(code, s, offset);
  }

  @Override
  @Transactional(readOnly = true)
  public PageResult<BoardPost> page(String code, int page, int size) {
    long total = countByCode(code);
    List<BoardPost> items = findPageByCode(code, page, size);
    return new PageResult<>(items, total, Math.max(1,page), Math.max(1,size));
  }

  @Override
  @Transactional(readOnly = true)
  public BoardPost findOne(Long id, boolean increaseView) {
    if (increaseView && id != null) boardMapper.increaseViews(id);
    return boardMapper.findOne(id);
  }
  
  @Override
  @Transactional(readOnly = true)
  public BoardCategory findByPath(String path) { 
      return boardMapper.findByPath(path);
  }

  @Override
  @Transactional(readOnly = true)
  public BoardCategory findByCode(String code) {
      return boardMapper.findByCode(code);
  }
  
  
  @Override
  @Transactional(readOnly = true)
  public List<BoardPost> findPostsByCategory(String categoryCode, int offset, int limit) {
      Map<String, Object> param = new HashMap<>();
      param.put("categoryCode", categoryCode);
      param.put("offset", offset);
      param.put("limit", limit);
      return boardMapper.findPostsByCategory(param);
  }

  @Override
  @Transactional(readOnly = true)
  public int countPostsByCategory(String categoryCode) {
      return boardMapper.countPostsByCategory(categoryCode);
  }

  @Override
  public void writePost(BoardPost post, List<MultipartFile> files) {
      // 1. 게시글 정보를 먼저 DB에 저장합니다. (auto-increment로 생성된 ID를 가져오기 위함)
	  boardMapper.insertPost(post);
	  
	  // 2. 업로드된 파일들을 처리합니다.
	  handleFileUpload(post, files);
  }


  @Override
  public void updatePost(BoardPost post, List<MultipartFile> files, List<Long> deleteFileIds) {
	  // 1. 삭제할 첨부파일 처리
	  if (deleteFileIds != null && !deleteFileIds.isEmpty()) {
		  // DB에서 파일 정보를 가져와서 실제 파일을 삭제
		  List<Attachment> filesToDelete = attachmentMapper.findByIds(deleteFileIds);
		  for (Attachment attachment : filesToDelete) {
			  File file = new File(attachment.getFilePath(), attachment.getStoredFilename());
			  if (file.exists()) {
				  file.delete();
			  }
		  }
		  // DB에서 파일 정보 삭제
		  attachmentMapper.deleteAttachments(deleteFileIds);
	  }
	  
	  // 2. 게시글 내용을 업데이트합니다.
	  boardMapper.updatePost(post);
	  
	  // 3. 새로 추가된 파일들을 처리합니다.
	  handleFileUpload(post, files);
  }

  @Override
  public void delete(Long id) {
    boardMapper.deletePost(id);
  }
  
  @Override
  public String boardAuth(Map<String, Object> map) {
	 return boardMapper.boardAuth(map);
  }
  @Override
  public List<Attachment> findAttachmentsByPostId(Long postId) {
      return attachmentMapper.findByPostId(postId);
  }
  
  @Override
  public Attachment findAttachmentById(Long id) {
      return attachmentMapper.findById(id);
  }
  
  
  /**
   * 파일 업로드 처리 및 DB 저장 공통 메소드
   * @param post 게시글 정보 (ID와 CategoryCode를 사용)
   * @param files 업로드된 파일 목록
   */
  private void handleFileUpload(BoardPost post, List<MultipartFile> files) {
	  if (files == null || files.isEmpty()) {
		  return;
	  }
	  
	  // 웹 애플리케이션 루트 내의 upload 폴더의 실제 경로를 가져옵니다.
      String uploadDir = servletContext.getRealPath("/resources/upload/");
      
      File dir = new File(uploadDir);
      if (!dir.exists()) {
          dir.mkdirs(); // 폴더가 없으면 생성
      }
      this.uploadPath = uploadDir;

	  List<Attachment> attachments = new ArrayList<>();
	  
	  for (MultipartFile file : files) {
		  if (file != null && !file.isEmpty()) {
			  String originalFilename = file.getOriginalFilename();
			  String storedFilename = UUID.randomUUID().toString() + "_" + originalFilename;
			  File dest = new File(uploadPath, storedFilename);
			  
			  try {
				  file.transferTo(dest); // 파일을 지정된 경로에 저장
				  
				  // Attachment 객체 생성 및 리스트에 추가
				// Attachment 객체 생성 및 값 설정
				  Attachment attachment = new Attachment();
				  attachment.setPostId(post.getId());
				  attachment.setCategoryCode(post.getCategoryCode());
				  attachment.setOriginalFilename(originalFilename);
				  attachment.setStoredFilename(storedFilename);
				  attachment.setFilePath(uploadPath);
				  attachment.setFileSize(file.getSize());
				  attachments.add(attachment);
				  
			  } catch (Exception e) {
				  e.printStackTrace(); // TODO: 예외 처리
			  }
		  }
	  }
	  
	  if (!attachments.isEmpty()) {
		  attachmentMapper.insertAttachments(attachments); // 파일 정보 리스트를 DB에 한번에 저장
	  }
  }

  // findOne 메소드 중복으로 하나 삭제
}
