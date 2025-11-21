package spr.com.hallyu.admin.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import spr.com.hallyu.admin.service.CategoryService;
import spr.com.hallyu.admin.service.MemberService;

@Controller
@RequestMapping("/admin/members")
public class MemberController {

    private final MemberService memberService;
    private final CategoryService categoryService; // 메뉴 트리를 가져오기 위해 주입
    
    @Autowired
    public MemberController(MemberService memberService,CategoryService categoryService) {
        this.memberService = memberService;
        this.categoryService = categoryService;
    }

    @GetMapping
    public String list(Model model) {
        // 20행 NPE 방지
        List<Map<String, Object>> member = memberService.memberList();
        System.out.println("### 조회된 회원 목록 데이터: " + member);
        for(int i=0;i<member.size();i++) {
        	//List<Map<String, Object>> member2 = member.;
        	
        }
        model.addAttribute("members", member);
        return "admin/member/list"; // 뷰 경로도 확인
    }
    
    /**
     * API: 전체 메뉴 목록을 트리 구조로 반환
     */
    @GetMapping("/api/menu-tree")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getMenuTree() {
        // CategoryService에 메뉴 트리 구조를 반환하는 메소드가 필요합니다.
        // 예: List<Map<String, Object>> menuTree = categoryService.getCategoryTree();
        // 아래는 임시 구현입니다. CategoryServiceImpl을 참고하여 getCategoryTree를 만들어야 합니다.
        List<Map<String, Object>> menuTree = categoryService.findTreeFlat(); // findTreeFlat()이 계층 구조를 반환한다고 가정
        return ResponseEntity.ok(menuTree);
    }

    /**
     * API: 특정 회원의 메뉴 권한 목록 반환
     */
    @GetMapping("/api/{username}/permissions")
    @ResponseBody
    public ResponseEntity<List<String>> getMemberPermissions(@PathVariable String username) {
        List<String> permissions = memberService.getMenuPermissions(username);
        return ResponseEntity.ok(permissions);
    }

    /**
     * API: 회원 메뉴 권한 저장
     */
    @PostMapping("/api/{username}/permissions")
    @ResponseBody
    public ResponseEntity<Void> saveMemberPermissions(@PathVariable String username, @RequestBody Map<String, List<String>> payload) {
        List<String> categoryCodes = payload.get("categoryCodes");
        memberService.saveMenuPermissions(username, categoryCodes);
        return ResponseEntity.ok().build();
    } 

   
}
