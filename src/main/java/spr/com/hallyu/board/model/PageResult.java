// src/main/java/spr/com/hallyu/board/model/PageResult.java
package spr.com.hallyu.board.model;

import java.util.List;

public class PageResult<T> {
  private List<T> items;
  private long total;
  private int page;
  private int size;
  private int lastPage;

  public PageResult(List<T> items, long total, int page, int size) {
    this.items = items;
    this.total = total;
    this.page = page;
    this.size = size;
    this.lastPage = (int)((total + size - 1) / size);
  }
  public List<T> getItems() { return items; }
  public long getTotal() { return total; }
  public int getPage() { return page; }
  public int getSize() { return size; }
  public int getLastPage() { return lastPage; }
}
