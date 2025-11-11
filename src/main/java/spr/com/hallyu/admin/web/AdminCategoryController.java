package spr.com.hallyu.admin.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import spr.com.hallyu.admin.service.CategoryService;

@Controller
@RequestMapping("/admin/categories")
public class AdminCategoryController {

    private final CategoryService categoryService;
    
    @Autowired
    public AdminCategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @GetMapping
    public String list(Model model) {
        // 20행 NPE 방지
        List<Map<String, Object>> categories = categoryService.findTreeFlat();
        model.addAttribute("categories", categories);
        return "admin/category/list"; // 뷰 경로도 확인
    }

    @PostMapping
    @ResponseBody
    public Map<String,Object> create(@RequestParam String code,
                                     @RequestParam String name,
                                     @RequestParam String path,
                                     @RequestParam(required=false) String parentCode) {
        Map<String,Object> dto = new HashMap<>();
        dto.put("code", code);
        dto.put("name", name);
        dto.put("path", path);
        dto.put("parentCode", parentCode);
        categoryService.create(dto);
        return ok();
    }

    @GetMapping("/{code}")
    @ResponseBody
    public Map<String, Object> findOne(@PathVariable String code) {
        return categoryService.findOne(code); // {code,name,path,useYn,visible, ...} 형태라고 가정
    }
    
    @PutMapping("/{code}")
    @ResponseBody
    public Map<String,Object> update(@PathVariable String code,
                                     @RequestParam String name,
                                     @RequestParam String path,
                                     @RequestParam String writeAuth,
                                     @RequestParam(defaultValue="Y") String useYn,
                                     @RequestParam(defaultValue="Y") String visible) {
        Map<String,Object> dto = new HashMap<>();
        dto.put("code", code);
        dto.put("name", name);
        dto.put("path", path);
        dto.put("writeAuth", writeAuth);
        dto.put("useYn", useYn);
        dto.put("visible", visible);
        categoryService.update(dto);
        return ok();
    }
    
 // /admin/categories 아래 컨트롤러
    @PostMapping("/{parentCode}/children")
    @ResponseBody
    public Map<String,Object> createChild(@PathVariable String parentCode,
                                          @RequestParam String code,
                                          @RequestParam String name,
                                          @RequestParam(required = false) String path,
                                          @RequestParam String writeAuth,
                                          @RequestParam(defaultValue="Y") String useYn,
                                          @RequestParam(defaultValue="Y") String visible) {
        Map<String,Object> dto = new HashMap<>();
        dto.put("parentCode", parentCode);
        dto.put("code", code);
        dto.put("name", name);
        dto.put("path", path);
        dto.put("writeAuth", writeAuth);
        dto.put("useYn", useYn);
        dto.put("visible", visible);
        // depth / sortOrder 는 서비스에서 자동 산정
        categoryService.createChild(dto);
        return ok(); // { "result": "ok" } 반환
    }

    @DeleteMapping("/{code}")
    @ResponseBody
    public Map<String,Object> delete(@PathVariable String code) {
        categoryService.delete(code);
        return ok();
    }

    @PostMapping("/{code}/moveUp")
    public String moveUp(@PathVariable String code) {
        categoryService.moveUp(code);
        return "redirect:/admin/categories";
    }

    @PostMapping("/{code}/moveDown")
    public String moveDown(@PathVariable String code) {
        categoryService.moveDown(code);
        return "redirect:/admin/categories";
    }

    @PostMapping("/{code}/toggleVisible")
    
    public String toggle(@PathVariable String code,
                                     @RequestParam String visible) {
        categoryService.toggleVisible(code, visible);
        return "redirect:/admin/categories";
    }

    @PostMapping("/reorder")
    @ResponseBody
    public Map<String,Object> reorder(@RequestParam(required=false) String parentCode,
                                      @RequestParam("codes") List<String> codes) {
        categoryService.reorder(parentCode, codes);
        return ok();
    }

    private Map<String,Object> ok() {
        Map<String,Object> m = new HashMap<>();
        m.put("ok", true);
        return m;
    }
}
