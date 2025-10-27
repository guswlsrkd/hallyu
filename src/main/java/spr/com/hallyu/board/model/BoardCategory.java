package spr.com.hallyu.board.model;

import java.util.Date;
import java.util.List;

public class BoardCategory {
    private String code;       // notice, k-food 등
    private String name;       // 메뉴 표시명
    private String path;       // URL 경로 (/notice, /k-food/recipes)
    private Integer sortOrder;
    private String useYn;
    private Boolean visible;
    private String parentCode;
    private Integer depth;
    private Date createdAt;
    private Date updatedAt;

    // --- 하위 메뉴 리스트 추가 ---
    private List<BoardCategory> children;

    // Getter / Setter
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPath() { return path; }
    public void setPath(String path) { this.path = path; }

    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }

    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }

    public Boolean getVisible() { return visible; }
    public void setVisible(Boolean visible) { this.visible = visible; }

    public String getParentCode() { return parentCode; }
    public void setParentCode(String parentCode) { this.parentCode = parentCode; }

    public Integer getDepth() { return depth; }
    public void setDepth(Integer depth) { this.depth = depth; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    public List<BoardCategory> getChildren() { return children; }
    public void setChildren(List<BoardCategory> children) { this.children = children; }
}
