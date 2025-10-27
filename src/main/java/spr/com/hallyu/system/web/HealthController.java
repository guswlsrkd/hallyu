// spr/com/hallyu/system/web/HealthController.java
package spr.com.hallyu.system.web;

import javax.annotation.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import spr.com.hallyu.system.mapper.HealthMapper;

@Controller
public class HealthController {
  @Resource private HealthMapper healthMapper;

  @GetMapping("/api/db-now")
  @ResponseBody
  public String dbNow() {
    return healthMapper.now(); // DB 연결되면 현재시간 문자열 반환
  }
}
