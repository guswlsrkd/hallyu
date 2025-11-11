// src/main/java/spr/com/hallyu/board/service/impl/BoardServiceImpl.java
package spr.com.hallyu.board.service.impl;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import spr.com.hallyu.board.mapper.BoardMapper;
import spr.com.hallyu.board.model.BoardCategory;
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
  @Transactional(readOnly = true)
  public BoardCategory findByPath(String path) { 
      return boardMapper.findByPath(path);
  }

  @Override
  @Transactional(readOnly = true)
  public BoardCategory findByCode(String code) {
      return boardMapper.findByCode(code);
  }
  
  
  @Override
  @Transactional(readOnly = true)
  public List<BoardPost> findPostsByCategory(String categoryCode, int offset, int limit) {
      Map<String, Object> param = new HashMap<>();
      param.put("categoryCode", categoryCode);
      param.put("offset", offset);
      param.put("limit", limit);
      return boardMapper.findPostsByCategory(param);
  }

  @Override
  @Transactional(readOnly = true)
  public int countPostsByCategory(String categoryCode) {
      return boardMapper.countPostsByCategory(categoryCode);
  }

  @Override
  public void writePost(BoardPost post) {
      boardMapper.insertPost(post);
  }

  @Override
  public void updatePost(BoardPost post) {
      boardMapper.updatePost(post);
  }

  @Override
  public void delete(Long id) {
    boardMapper.deletePost(id);
  }

  // findOne 메소드 중복으로 하나 삭제
}
