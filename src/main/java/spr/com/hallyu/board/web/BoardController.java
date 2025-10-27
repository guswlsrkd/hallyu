// spr/com/hallyu/system/web/HealthController.java
package spr.com.hallyu.board.web;

import javax.annotation.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import spr.com.hallyu.board.service.BoardService;
import spr.com.hallyu.board.service.impl.BoardServiceImpl;
import spr.com.hallyu.system.mapper.HealthMapper;

@Controller
@RequestMapping("/")
public class BoardController {
    @Resource BoardService boardService;

    // 상위 or 하위 카테고리 게시글 목록
    @GetMapping({"{slug}", "{slug}/{sub}"})
    public String boardList(@PathVariable String slug,
                            @PathVariable(required=false) String sub,
                            @RequestParam(defaultValue="1") int page,
                            @RequestParam(defaultValue="10") int size,
                            Model model) {

        // code 결정 (sub가 있으면 slug-sub, 없으면 slug)
        String code = (sub == null) ? slug : slug + "-" + sub;

        // DB에서 카테고리/게시글 조회
        model.addAttribute("category", code);
        model.addAttribute("items", boardService.findPageByCode(code, page, size));
        model.addAttribute("page", page);

        // 상위 active, 하위 active 표시
        model.addAttribute("selected", slug);
        model.addAttribute("subSelected", code);

        return "board/list"; // /WEB-INF/jsp/board/list.jsp
    }
}