/**
 * @Class Name  : MessageUtil.java
 * @Description : 메시지 처리 관련 유틸리티
 * @Modification Information
 *
 *     수정일         수정자                   수정내용
 *     -------          --------        ---------------------------
 *   2009.02.13       이삼섭                  최초 생성
 *
 * @author 공통 서비스 개발팀 이삼섭
 * @since 2009. 02. 13
 * @version 1.0
 * @see
 *
 */
package spr.com.hallyu.common.utils;

import java.util.Locale;

import org.springframework.context.support.MessageSourceAccessor;

public class MessageUtil {

	private static MessageSourceAccessor msAcc = null;

	public void setMessageSourceAccessor(MessageSourceAccessor msAcc) {
		MessageUtil.msAcc = msAcc;
	}

	/**
	 * KEY에 해당하는 메세지 반환
	 * @param key
	 * @return
	 */
	public static String getInfoMsg(String key) {
		return msAcc.getMessage(key);
	}

	/**
	 * KEY에 해당하는 메세지 반환
	 * @param key
	 * @param objs
	 * @return
	 */
	public static String getInfoMsg(String key, Object[] objs) {
		return msAcc.getMessage(key, objs);
	}

}