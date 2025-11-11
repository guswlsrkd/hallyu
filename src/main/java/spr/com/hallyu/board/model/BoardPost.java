// src/main/java/spr/com/hallyu/board/model/BoardPost.java
package spr.com.hallyu.board.model;

import java.util.Date;

public class BoardPost {
	private Long id;
    private String categoryCode;
    private String title;
    private String content;
    private String writer;
    private int viewCnt;
    private boolean isNotice; // isNotice 필드 추가
    private Date createdAt;
    private Date updatedAt;
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getCategoryCode() {
		return categoryCode;
	}
	public void setCategoryCode(String categoryCode) {
		this.categoryCode = categoryCode;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public int getViewCnt() {
		return viewCnt;
	}
	public void setViewCnt(int viewCnt) {
		this.viewCnt = viewCnt;
	}
	public Date getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}
	public Date getUpdatedAt() {
		return updatedAt;
	}
	public void setUpdatedAt(Date updatedAt) {
		this.updatedAt = updatedAt;
	}
	// isNotice getter/setter 추가
	public boolean getIsNotice() { // boolean 타입은 isNotice() 또는 getIsNotice()
		return isNotice;
	}
	public void setIsNotice(boolean isNotice) {
		this.isNotice = isNotice;
	}

 
}
