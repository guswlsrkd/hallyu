// src/main/java/spr/com/hallyu/board/service/impl/BoardServiceImpl.java
package spr.com.hallyu.board.service.impl;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

import spr.com.hallyu.board.mapper.BoardMapper;
import spr.com.hallyu.board.model.BoardPost;
import spr.com.hallyu.board.model.PageResult;
import spr.com.hallyu.board.service.BoardService;

@Service
@Transactional
public class BoardServiceImpl implements BoardService {

  @Resource
  private BoardMapper boardMapper;

  @Override
  @Transactional(readOnly = true)
  public long countByCode(String code) {
    return boardMapper.countByCode(code);
  }

  @Override
  @Transactional(readOnly = true)
  public List<BoardPost> findPageByCode(String code, int page, int size) {
    int p = Math.max(1, page);
    int s = Math.max(1, size);
    int offset = (p - 1) * s;
    return boardMapper.findPageByCode(code, s, offset);
  }

  @Override
  @Transactional(readOnly = true)
  public PageResult<BoardPost> page(String code, int page, int size) {
    long total = countByCode(code);
    List<BoardPost> items = findPageByCode(code, page, size);
    return new PageResult<>(items, total, Math.max(1,page), Math.max(1,size));
  }

  @Override
  @Transactional(readOnly = true)
  public BoardPost findOne(Long id, boolean increaseView) {
    if (increaseView && id != null) boardMapper.increaseViews(id);
    return boardMapper.findOne(id);
  }

  @Override
  public Long save(BoardPost p) {
    if (p.getId() == null) {
      if (p.getIsNotice() == null) p.setIsNotice(false);
      boardMapper.insertPost(p); // useGeneratedKeys=true → id 채워짐
      return p.getId();
    } else {
      if (p.getIsNotice() == null) p.setIsNotice(false);
      boardMapper.updatePost(p);
      return p.getId();
    }
  }

  @Override
  public void delete(Long id) {
    boardMapper.deletePost(id);
  }
}
