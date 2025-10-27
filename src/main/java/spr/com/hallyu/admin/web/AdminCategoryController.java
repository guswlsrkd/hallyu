package spr.com.hallyu.admin.web;

import javax.annotation.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import spr.com.hallyu.admin.service.CategoryService;
import spr.com.hallyu.board.model.BoardCategory;

@Controller
@RequestMapping("/admin/category")
public class AdminCategoryController {

  @Resource private CategoryService categoryService;

  // 계층형(들여쓰기) 리스트
  @GetMapping("/list")
  public String list(@RequestParam(required=false) String edit, Model model){
    model.addAttribute("items", categoryService.findTreeFlat()); // depth대로 플랫
    if (edit != null) model.addAttribute("editItem", categoryService.findOne(edit));
    return "admin/category/list";
  }

  // 생성 (상위/하위 모두 사용) : code 신규 필요
  @PostMapping("/create")
  public String create(BoardCategory c){
    categoryService.create(c);
    return "redirect:/admin/category/list";
  }

  // 수정
  @PostMapping("/update")
  public String update(BoardCategory c){
    categoryService.update(c);
    return "redirect:/admin/category/list?edit=" + c.getCode();
  }

  // 삭제
  @PostMapping("/delete")
  public String delete(@RequestParam String code){
    categoryService.delete(code);
    return "redirect:/admin/category/list";
  }

  // 정렬 이동
  @PostMapping("/move-up")
  public String moveUp(@RequestParam String code){
    categoryService.moveUp(code);
    return "redirect:/admin/category/list";
  }

  @PostMapping("/move-down")
  public String moveDown(@RequestParam String code){
    categoryService.moveDown(code);
    return "redirect:/admin/category/list";
  }
}
