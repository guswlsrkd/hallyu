// spr/com/hallyu/system/web/HealthController.java
package spr.com.hallyu.board.web;

import java.io.File;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import spr.com.hallyu.board.model.BoardCategory;
import spr.com.hallyu.board.model.BoardPost;
import spr.com.hallyu.board.service.BoardService;
import spr.com.hallyu.comment.service.CommentService;
import spr.com.hallyu.common.utils.CamelMap;
import spr.com.hallyu.file.model.Attachment;

import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("/board")
public class BoardController {
	@Autowired
    private BoardService boardService;
	
	@Autowired
	private CommentService commentService;
	



	@GetMapping("/{code}")
    public String listByCode(@PathVariable String code,
                             @RequestParam(defaultValue="1") int page,
                             @RequestParam(defaultValue="10") int size,
                             Model model,
                             HttpSession session) {

		Map<String, Object> category = boardService.findByCode(code);
		System.out.println("useYn : "+(String)category.get("use_yn"));
        if (category == null || !"Y".equalsIgnoreCase((String)category.get("use_yn"))) {
            throw new IllegalArgumentException("존재하지 않거나 비활성 카테고리: " + code);
        }
        session.setAttribute("categoryCode", code);//세션으로관리
        // 현재 로그인한 사용자 정보를 가져옴
        String writer = SecurityContextHolder.getContext().getAuthentication().getName();
        System.out.println("writer : "+writer);
        String loginAuth = (String)session.getAttribute("loginAuth")==null?"":(String)session.getAttribute("loginAuth");
        if(!loginAuth.endsWith("ROLE_ADMIN")) {
        	 Map<String, Object> map = new HashMap();
        	 map.put("userId", writer);
        	 map.put("code", code);
        	 model.addAttribute("boardAuth", boardService.boardAuth(map));
        }
        System.out.println("loginAuth: "+loginAuth);
        int offset = (page - 1) * size;
        model.addAttribute("category", category);
        model.addAttribute("list", boardService.findPostsByCategory(code, offset, size));
        model.addAttribute("total", boardService.countPostsByCategory(code));
        model.addAttribute("page", page);
        model.addAttribute("pageSize", size);
        return "board/list";
    }
	
	@GetMapping("/{code}/write")
    public String writeForm(@PathVariable("code") String code, Model model) {
        // 글을 작성할 게시판의 정보를 가져와서 뷰에 전달합니다.
		Map<String, Object> category = boardService.findByCode(code);
		System.out.println("use_yn : "+(String)category.get("use_yn"));
        if (category == null || !"Y".equalsIgnoreCase((String)category.get("use_yn"))) {
            throw new IllegalArgumentException("존재하지 않거나 비활성 카테고리: " + code);
        }

    
        model.addAttribute("category", category);
        return "board/write";
    }
	
	@PostMapping("/{code}/write") // RESTful URL에 맞게 수정
    public String writePost(@PathVariable("code") String code,
                            @ModelAttribute BoardPost post,
                            @RequestParam(value = "files", required = false) List<MultipartFile> files) {
    		
        // 현재 로그인한 사용자 정보를 가져와 작성자로 설정
        String writer = SecurityContextHolder.getContext().getAuthentication().getName();
        post.setWriter(writer);
        post.setCategoryCode(code); // URL 경로에서 받은 code를 categoryCode로 설정
     

       
        boardService.writePost(post, files);
        // 글쓰기 완료 후 해당 게시판 목록 페이지로 리다이렉트
        return "redirect:/board/" + code;
    }

    @GetMapping("/post/{id}")
    public String viewPost(@PathVariable("id") Long id, Model model) {
        // 조회수를 1 증가시키고 게시글 정보를 가져옵니다.
        BoardPost post = boardService.findOne(id, true);
        if (post == null) {
            throw new IllegalArgumentException("존재하지 않는 게시글입니다: " + id);
        }
        // 게시글이 속한 카테고리 정보를 조회합니다.
        //BoardCategory category = boardService.findByCode(post.getCategoryCode());
        Map<String, Object> category = boardService.findByCode(post.getCategoryCode());
        // 첨부파일 목록을 조회합니다.
        List<Attachment> attachments = boardService.findAttachmentsByPostId(id);
        // 댓글 목록을 조회합니다.
        List<CamelMap> comments = commentService.getCommentsByPostId(id);
        model.addAttribute("post", post);
        model.addAttribute("category", category); // 모델에 카테고리 정보 추가
        model.addAttribute("attachments", attachments); // 모델에 첨부파일 목록 추가
        model.addAttribute("comments", comments); // 모델에 댓글 목록 추가
        return "board/view";
    }

    @GetMapping("/post/{id}/edit")
    public String editForm(@PathVariable("id") Long id, Model model) {
        BoardPost post = boardService.findOne(id, false); // 조회수 증가 없이 게시글 정보 가져오기

        // 권한 체크: 현재 로그인한 사용자가 글 작성자이거나 관리자인지 확인
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentUsername = authentication.getName();
        boolean isAdmin = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

        if (!post.getWriter().equals(currentUsername) && !isAdmin) {
            throw new AccessDeniedException("수정할 권한이 없습니다.");
        }
        List<Attachment> attachments = boardService.findAttachmentsByPostId(id);
        model.addAttribute("attachments", attachments);
        model.addAttribute("post", post);
        return "board/edit";
    }

    @PostMapping("/post/{id}/edit")
    public String updatePost(@PathVariable("id") Long id, 
            @ModelAttribute BoardPost post,
            @RequestParam(value = "files", required = false) List<MultipartFile> files,
            @RequestParam(value = "deleteFileIds", required = false) List<Long> deleteFileIds,
            HttpSession session){
        post.setId(id); // URL에서 받은 id를 post 객체에 설정
        String categoryCode = (String)session.getAttribute("categoryCode");
        post.setCategoryCode(categoryCode);
        // 여기서도 수정 권한을 한번 더 체크하는 것이 더 안전합니다.
        boardService.updatePost(post, files, deleteFileIds);

        return "redirect:/board/post/" + id;
    }

    @PostMapping("/post/{id}/delete")
    public String deletePost(@PathVariable("id") Long id) {
        // 삭제 전, 게시글 정보를 가져와서 권한 체크 및 리다이렉트 경로 확보
        BoardPost post = boardService.findOne(id, false);
        if (post == null) {
            throw new IllegalArgumentException("존재하지 않는 게시글입니다: " + id);
        }

        // 권한 체크: 현재 로그인한 사용자가 글 작성자이거나 관리자인지 확인
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentUsername = authentication.getName();
        boolean isAdmin = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

        if (!post.getWriter().equals(currentUsername) && !isAdmin) {
            throw new AccessDeniedException("삭제할 권한이 없습니다.");
        }

        boardService.delete(id);
        return "redirect:/board/" + post.getCategoryCode();
    }
    
    @GetMapping("/download/attachment/{id}")
    @ResponseBody
    public ResponseEntity<Resource> downloadAttachment(@PathVariable Long id, HttpServletResponse response) throws Exception {
        Attachment fileInfo = boardService.findAttachmentById(id);

        if (fileInfo == null) {
            throw new IllegalArgumentException("존재하지 않는 파일입니다: " + id);
        }

        // 서버에 저장된 파일 경로
        File file = new File(fileInfo.getFilePath(), fileInfo.getStoredFilename());
        if (!file.exists()) {
            throw new IllegalArgumentException("파일을 찾을 수 없습니다: " + file.getAbsolutePath());
        }

        Resource resource = new FileSystemResource(file);

        // 다운로드 시 표시될 파일명 인코딩
        String encodedFilename = URLEncoder.encode(fileInfo.getOriginalFilename(), "UTF-8").replaceAll("\\+", "%20");

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedFilename + "\"")
                .header(HttpHeaders.CONTENT_TYPE, "application/octet-stream")
                .header(HttpHeaders.CONTENT_LENGTH, String.valueOf(file.length()))
                .body(resource);
    }

}
