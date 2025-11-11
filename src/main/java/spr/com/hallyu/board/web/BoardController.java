// spr/com/hallyu/system/web/HealthController.java
package spr.com.hallyu.board.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import spr.com.hallyu.board.model.BoardCategory;
import spr.com.hallyu.board.model.BoardPost;
import spr.com.hallyu.board.service.BoardService;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;

@Controller
@RequestMapping("/board")
public class BoardController {
	@Autowired
    private BoardService boardService;
	



	@GetMapping("/{code}")
    public String listByCode(@PathVariable String code,
                             @RequestParam(defaultValue="1") int page,
                             @RequestParam(defaultValue="10") int size,
                             Model model) {

        BoardCategory category = boardService.findByCode(code);
        if (category == null || !"Y".equalsIgnoreCase(category.getUseYn())) {
            throw new IllegalArgumentException("존재하지 않거나 비활성 카테고리: " + code);
        }

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
        BoardCategory category = boardService.findByCode(code);
        if (category == null || !"Y".equalsIgnoreCase(category.getUseYn())) {
            throw new IllegalArgumentException("존재하지 않거나 비활성 카테고리: " + code);
        }

    
        model.addAttribute("category", category);
        return "board/write";
    }
	
	@PostMapping("/{code}/write") // RESTful URL에 맞게 수정
    public String writePost(@PathVariable("code") String code,
                            @ModelAttribute BoardPost post) {

        // 현재 로그인한 사용자 정보를 가져와 작성자로 설정
        String writer = SecurityContextHolder.getContext().getAuthentication().getName();
        post.setWriter(writer);
        post.setCategoryCode(code); // URL 경로에서 받은 code를 categoryCode로 설정
     

        boardService.writePost(post);

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
        model.addAttribute("post", post);
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

        model.addAttribute("post", post);
        return "board/edit";
    }

    @PostMapping("/post/{id}/edit")
    public String updatePost(@PathVariable("id") Long id, @ModelAttribute BoardPost post) {
        post.setId(id); // URL에서 받은 id를 post 객체에 설정
        
        // 여기서도 수정 권한을 한번 더 체크하는 것이 더 안전합니다.
        boardService.updatePost(post);

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
}
