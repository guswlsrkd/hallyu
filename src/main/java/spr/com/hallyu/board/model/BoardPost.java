// src/main/java/spr/com/hallyu/board/model/BoardPost.java
package spr.com.hallyu.board.model;

import java.util.Date;

public class BoardPost {
  private Long id;
  private String code;      // notice, k-food, ...
  private String title;
  private String content;   // SmartEditor2 HTML
  private String writer;
  private Integer views;
  private Boolean isNotice;
  private Date createdAt;
  private Date updatedAt;

  // --- getter / setter ---
  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }
  public String getCode() { return code; }
  public void setCode(String code) { this.code = code; }
  public String getTitle() { return title; }
  public void setTitle(String title) { this.title = title; }
  public String getContent() { return content; }
  public void setContent(String content) { this.content = content; }
  public String getWriter() { return writer; }
  public void setWriter(String writer) { this.writer = writer; }
  public Integer getViews() { return views; }
  public void setViews(Integer views) { this.views = views; }
  public Boolean getIsNotice() { return isNotice; }
  public void setIsNotice(Boolean isNotice) { this.isNotice = isNotice; }
  public Date getCreatedAt() { return createdAt; }
  public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
  public Date getUpdatedAt() { return updatedAt; }
  public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
}
