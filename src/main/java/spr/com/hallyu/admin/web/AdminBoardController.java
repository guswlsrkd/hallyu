// src/main/java/spr/com/hallyu/admin/web/AdminBoardController.java
package spr.com.hallyu.admin.web;

import javax.annotation.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import spr.com.hallyu.board.service.BoardService;

@Controller
@RequestMapping("/admin/board") // ← 클래스 레벨 매핑
public class AdminBoardController {

  @Resource
  private BoardService boardService; // 인터페이스 타입으로 주입

  @GetMapping("/posts") // ← 메서드 매핑
  public String posts(@RequestParam String code,
                      @RequestParam(defaultValue="1") int page,
                      @RequestParam(defaultValue="10") int size,
                      Model model) {
	System.out.println("22222222222222222");  
    model.addAttribute("code", code);
    model.addAttribute("items", boardService.findPageByCode(code, page, size));
    model.addAttribute("page", page);
    model.addAttribute("size", size);
    System.out.println("33333333333333");
    return "admin/board/posts"; // /WEB-INF/jsp/admin/board/posts.jsp
  }

  // 확인용 핑 엔드포인트 (임시)
  @GetMapping("/ping")
  @ResponseBody
  public String ping() { return "OK"; }
}
