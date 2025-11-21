package spr.com.hallyu.admin.model;


import java.util.Date;
import java.time.LocalDateTime;

public class AdminBoardPost {
    private Long id;
    private String categoryCode;
    private String title;
    private String content;
    private String writerId; // 작성자 ID
    private int viewCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    // 필요한 경우 관리자용 추가 필드 (예: 삭제 여부, 블라인드 처리 여부 등)
    // private boolean isDeleted;
    // private boolean isBlinded;

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

    public String getWriterId() {
        return writerId;
    }

    public void setWriterId(String writerId) {
        this.writerId = writerId;
    }

    public int getViewCount() {
        return viewCount;
    }

    public void setViewCount(int viewCount) {
        this.viewCount = viewCount;
    }

    public Date getCreatedAt() {
        return java.sql.Timestamp.valueOf(createdAt);
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}