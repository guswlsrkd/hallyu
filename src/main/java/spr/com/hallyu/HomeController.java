package spr.com.hallyu;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class HomeController {
  @GetMapping("/")
  public String index(Model model) {
    model.addAttribute("msg", "Hallyu up & running!");
    return "home/index";
  }
  
  @GetMapping("/list")
  public String list(Model model) {
    model.addAttribute("msg", "Hallyu up & running!");
    return "home/b_list";
  }
  
  @GetMapping("/view")
  public String view(Model model) {
    model.addAttribute("msg", "Hallyu up & running!");
    return "home/b_view";
  }
  
  // 매핑/스캔 확인용
  @GetMapping("/ping")
  @ResponseBody
  public String ping() { return "pong"; }
}
