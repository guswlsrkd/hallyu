package spr.com.hallyu.admin.web;
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
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.RequiredArgsConstructor;
import spr.com.hallyu.admin.service.CategoryService;
import spr.com.hallyu.board.model.BoardPost;
import spr.com.hallyu.admin.model.AdminBoardPost; // AdminBoardPost 모델 사용
import spr.com.hallyu.admin.service.AdminBoardService; // AdminBoardService 사용

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin/board")
public class AdminBoardController {

    private final AdminBoardService adminBoardService; // AdminBoardService 주입
    private final CategoryService categoryService;
    
    @Autowired
    public AdminBoardController(AdminBoardService adminBoardService, CategoryService categoryService) {
        this.adminBoardService = adminBoardService;
        this.categoryService = categoryService;
    }

    @GetMapping
    public String redirectToDefaultBoard() {
        // 기본 게시판을 "notice"로 설정하고 해당 URL로 리다이렉트합니다.
        return "redirect:/admin/board/notice";
    }

    @GetMapping("/{code}")
    public String postList(@PathVariable String code,
                           @RequestParam(defaultValue = "1") int page,
                           Model model) {
        int limit = 10; // 페이지당 게시글 수
        int offset = (page - 1) * limit;

        List<AdminBoardPost> posts = adminBoardService.getPostsByCategory(code, limit, offset); // AdminBoardService 호출
        int totalPosts = adminBoardService.getTotalPostsCount(code); // AdminBoardService 호출
        Map<String, Object> category = categoryService.findOne(code);
        List<Map<String, Object>> allCategories = categoryService.findTreeFlat(); // 전체 카테고리 목록 조회

        model.addAttribute("category", category);
        model.addAttribute("posts", posts);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", (int) Math.ceil((double) totalPosts / limit));
        model.addAttribute("allCategories", allCategories); // 전체 카테고리 목록을 모델에 추가
        return "admin/board/list"; // 뷰 경로
    }

    @GetMapping("/api/posts/{id}")
    @ResponseBody
    public AdminBoardPost getPost(@PathVariable Long id) {
        // 모달에 데이터를 채우기 위한 것이므로 조회수는 증가시키지 않음 (false)
    	System.out.println("44444");
        return adminBoardService.findOne(id, false);
    }

    @PostMapping("/api/posts/{id}")
    @ResponseBody
    public Map<String, Object> updatePost(@PathVariable Long id, AdminBoardPost post) {
        post.setId(id);
        adminBoardService.updatePost(post);
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        return response;
    }
    
    @PostMapping("/api/{code}/write") // RESTful URL에 맞게 수정
    @ResponseBody
    public Map<String, Object> writePost(@PathVariable("code") String code,
                            @ModelAttribute AdminBoardPost post,
                            HttpSession session) {
    	System.out.println("333333333");
    	 // 현재 로그인한 사용자 ID 가져오기
    	String userId = (String)session.getAttribute("ADMIN_LOGIN");
        //String writerId = SecurityContextHolder.getContext().getAuthentication().getName();
        post.setWriterId(userId); // 작성자 ID 설정
        post.setCategoryCode(code); // 카테고리 코드 설정

        adminBoardService.writePost(post); // 게시글 삽입 (이후 post 객체에 자동 생성된 ID가 담겨야 함)

        Map<String, Object> response = new HashMap<>();
        // 삽입 후, ID가 포함된 완전한 게시글 정보를 다시 조회하여 반환
        return response;
       
    } 
    
    @PostMapping("/api/{code}/{id}/delete") // RESTful URL에 맞게 수정
    @ResponseBody
    public Map<String, Object> deletePost(@PathVariable("code") String code,@PathVariable("id") Long id,
                            @ModelAttribute AdminBoardPost post,
                            HttpSession session) {
    	System.out.println("4444666666");
    	System.out.println("code"+code);
    	System.out.println("id"+id);
    	 // 현재 로그인한 사용자 ID 가져오기
    	String userId = (String)session.getAttribute("ADMIN_LOGIN");
        //String writerId = SecurityContextHolder.getContext().getAuthentication().getName();
        post.setId(id);
        post.setCategoryCode(code); // 카테고리 코드 설정

        adminBoardService.deletePost(post); // 게시글 삽입 (이후 post 객체에 자동 생성된 ID가 담겨야 함)

        Map<String, Object> response = new HashMap<>();
        // 삽입 후, ID가 포함된 완전한 게시글 정보를 다시 조회하여 반환
        response.put("success", true);
        return response;
       
    } 
    
}
