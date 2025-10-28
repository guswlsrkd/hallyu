package spr.com.hallyu.common.utils;

import java.text.MessageFormat;
import java.util.Locale;

import org.springframework.context.MessageSource;

public class AjaxException extends Exception {

	private static final long serialVersionUID = 1L;
	protected String message = null;
	protected String messageKey = null;
	protected Object[] messageParameters = null;
	protected Exception wrappedException = null;


	public AjaxException() {
		this("BaseException without message", null, null);
	}

	public AjaxException(String defaultMessage) {
		this(defaultMessage, null, null);
	}

	public AjaxException(String defaultMessage, Exception wrappedException) {
		this(defaultMessage, null, wrappedException);
	}

	public AjaxException(String defaultMessage, Object[] messageParameters, Exception wrappedException) {
		String userMessage = defaultMessage;

		if (messageParameters != null) {
			userMessage = MessageFormat.format(defaultMessage, messageParameters);
		}

		this.message = userMessage;
		this.wrappedException = wrappedException;
	}

	public AjaxException(MessageSource messageSource, String messageKey) {
		this(messageSource, messageKey, null, null, Locale.getDefault(), null);
	}

	public AjaxException(MessageSource messageSource, String messageKey, Exception wrappedException) {
		this(messageSource, messageKey, null, null, Locale.getDefault(), wrappedException);
	}

	public AjaxException(MessageSource messageSource, String messageKey, Locale locale, Exception wrappedException) {
		this(messageSource, messageKey, null, null, locale, wrappedException);
	}

	public AjaxException(MessageSource messageSource, String messageKey, Object[] messageParameters, Locale locale, Exception wrappedException) {
		this(messageSource, messageKey, messageParameters, null, locale, wrappedException);
	}

	public AjaxException(MessageSource messageSource, String messageKey, Object[] messageParameters, Exception wrappedException) {
		this(messageSource, messageKey, messageParameters, null, Locale.getDefault(), wrappedException);
	}

	public AjaxException(MessageSource messageSource, String messageKey, Object[] messageParameters, String defaultMessage, Exception wrappedException) {
		this(messageSource, messageKey, messageParameters, defaultMessage, Locale.getDefault(), wrappedException);
	}

	public AjaxException(MessageSource messageSource, String messageKey, Object[] messageParameters, String defaultMessage, Locale locale, Exception wrappedException) {
		this.messageKey = messageKey;
		this.messageParameters = messageParameters;
		this.message = messageSource.getMessage(messageKey, messageParameters, defaultMessage, locale);
		this.wrappedException = wrappedException;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
}
