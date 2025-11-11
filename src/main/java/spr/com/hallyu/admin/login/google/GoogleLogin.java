package spr.com.hallyu.admin.login.google;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.RequestMapping;

public class GoogleLogin {

	
	@RequestMapping("/admin/login/google")
	public void debug(HttpServletRequest req) {
	    System.out.println("CALLBACK URL=" + req.getRequestURL());
	    System.out.println("QS=" + req.getQueryString());
	}

	
}
