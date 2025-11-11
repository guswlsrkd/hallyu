package spr.com.hallyu.config;

import java.util.List;
import javax.annotation.Resource;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import spr.com.hallyu.board.model.BoardCategory;
import spr.com.hallyu.category.mapper.CategoryMapper;

@ControllerAdvice
public class GlobalControllerAdvice {

    @Resource
    private CategoryMapper categoryMapper;

    @ModelAttribute("menuTree")
    public List<BoardCategory> populateMenuTree() {
        // 상위 메뉴 조회
        List<BoardCategory> topMenus = categoryMapper.findTopMenus();

        // 하위 메뉴 채워넣기
        for (BoardCategory parent : topMenus) {
            List<BoardCategory> children = categoryMapper.findChildren(parent.getCode());
            parent.setChildren(children);
            System.out.println("children : "+parent.getChildren().toString());
        }

        return topMenus;
    }
}
