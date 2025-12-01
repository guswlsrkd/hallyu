package spr.com.hallyu.admin.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import spr.com.hallyu.admin.mapper.AdminBoardMapper; // AdminBoardMapper 사용
import spr.com.hallyu.admin.model.AdminBoardPost; // AdminBoardPost 모델 사용
import spr.com.hallyu.admin.service.AdminBoardService; // AdminBoardService 구현
import spr.com.hallyu.board.model.BoardPost;
import spr.com.hallyu.file.model.Attachment;
import spr.com.hallyu.file.mapper.AttachmentMapper;
import javax.servlet.ServletContext;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class AdminBoardServiceImpl implements AdminBoardService {

    private final AdminBoardMapper adminBoardMapper; // AdminBoardMapper 주입
    private final AttachmentMapper attachmentMapper; // attachmentMapper 주입
    
    @Autowired
    private ServletContext servletContext;
    
    private String uploadPath;

    @Autowired
    public AdminBoardServiceImpl(AdminBoardMapper adminBoardMapper,AttachmentMapper attachmentMapper) {
        this.adminBoardMapper = adminBoardMapper;
        this.attachmentMapper = attachmentMapper;
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
    public void writePost(AdminBoardPost post,List<MultipartFile> files, List<Long> deleteFileIds) {
    	// 1. 게시글 정보를 먼저 DB에 저장합니다.
    	adminBoardMapper.insertPost(post);
    	
    	// 2. 업로드된 파일들을 처리합니다.
  	  	handleFileUpload(post, files);
    }

    
    @Override
    public void updatePost(AdminBoardPost post,List<MultipartFile> files, List<Long> deleteFileIds) {
      System.out.println("44sfdfsfsdfsdfdsfds");
      // 1. 삭제할 첨부파일 처리
  	  if (deleteFileIds != null && !deleteFileIds.isEmpty()) {
  		// DB에서 파일 정보를 가져와서 실제 파일을 삭제
		  List<Attachment> filesToDelete = attachmentMapper.findByIds(deleteFileIds);
		  for(Attachment attachment :filesToDelete) {
			  File file = new File(attachment.getFilePath(), attachment.getStoredFilename());
			  if (file.exists()) {
				  file.delete();
			  }
		  }
		// DB에서 파일 정보 삭제
		  attachmentMapper.deleteAttachments(deleteFileIds);
  	  }
    	adminBoardMapper.updatePost(post);
    	// 3. 새로 추가된 파일들을 처리합니다.
  	    handleFileUpload(post, files);
    }
    
    @Override
    public void deletePost(AdminBoardPost post) {
        adminBoardMapper.deletePost(post);
    }
    
    /**
     * 파일 업로드 처리 및 DB 저장 공통 메소드
     * @param post 게시글 정보 (ID와 CategoryCode를 사용)
     * @param files 업로드된 파일 목록
     */
    private void handleFileUpload(AdminBoardPost post, List<MultipartFile> files) {
    	System.out.println("files : "+files);
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
        	System.out.println("dfdsfdfsdfsfsfsfsdf");
  		  attachmentMapper.insertAttachments(attachments); // 파일 정보 리스트를 DB에 한번에 저장
  	    }
        
    }
  
    
}
